part of '../controllers.dart';
class MenuPrincipalController extends GetxController {
  // ======================= ⚙️ ESTADOS ==========================
  final RxBool peticionServerState = false.obs;
  final Rx<Uint8List?> fotoPerfilBytes = Rx<Uint8List?>(null);
  final RxString userPref = ''.obs;

  final CheckInternetConnection internetChecker = CheckInternetConnection();
  late StreamSubscription connectionSubscription;
  final Rx<ConnectionStatus> status = ConnectionStatus.online.obs;
  // ======================= 🧩 DEPENDENCIAS ======================
  final GpsController gpsController = Get.find<GpsController>();
  final ModulosRepository _apiModulosRepository = Get.find<ModulosRepository>();
  final AlertaViolenciaRepository _apiAlertaViolenciaRepository = Get.find<AlertaViolenciaRepository>();
  final LocalStoreImpl _localStoreImpl = Get.find<LocalStoreImpl>();

  // ======================= 🗂️ DATOS ============================
  final RxList<Modulo> listaModulo = <Modulo>[].obs;
  final RxList<Permiso> listaPermiso = <Permiso>[].obs;
  final RxList<ListaAlerta> listaAlertasUsuario = <ListaAlerta>[].obs;

  Rx<Modulo> datosModulos = Modulo(
    descripcionModulo: '',
    imgBase64: '',
    idGenEstado: 0,
    idUpcModulosMovil: 0,
    imagenModulo: '',
    ordenModulo: 0,
    tituloModulo: '',
  ).obs;

  Rx<GaleryCameraModel?> mGaleryCameraModel = Rx<GaleryCameraModel?>(null);

  String acuerdo = "";

  // =============================================================
  // 🔹 CICLO DE VIDA
  // =============================================================
  @override
  void onInit() {
    super.onInit();
    verificaTConexion();
    _verificaDatos();
    _cargarFotoPerfil();
    connectionStatusController();
    initPermisosNotificaciones();
    _initNotificaciones();
  }

  @override
  void onReady() {
    super.onReady();
    _init();
    consultaAlertasUsuarioNumero();
  }

  // =============================================================
  // 🧠 INICIALIZACIÓN Y CONFIGURACIÓN
  // =============================================================

  Future<void> _init() async {
    await consultaPermisosPolicia();
    await generaToken();
    print("🌎 Locale actual: ${Get.deviceLocale}");
  }

  Future<void> _cargarFotoPerfil() async {
    final bytes = await _localStoreImpl.getFoto();
    if (bytes != null) {
      print("🖼️ Foto de perfil cargada correctamente (${bytes.length} bytes)");
      fotoPerfilBytes.value = bytes;
    } else {
      print("⚠️ No se encontró foto de perfil en almacenamiento local.");
    }
  }


  // =============================================================
  // 🌐 CONTROL DE CONEXIÓN
  // =============================================================
  @override
  void onClose() {
    connectionSubscription.cancel();
    internetChecker.close();
    super.onClose();
  }


  void connectionStatusController() {
    connectionSubscription =
        internetChecker.internetStatus().listen((newStatus) {
          status.value = newStatus;
        });

    if (status.value == ConnectionStatus.online) {
      verificaTConexion();
    } else {
      _cargarModulosOffline();
    }
  }

  Future<void> verificaTConexion() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await cargarDatosLista();
      } else {
        await _cargarModulosOffline();
      }
    } on SocketException {
      await _cargarModulosOffline();
    }
  }

  Future<void> _cargarModulosOffline() async {
    final list = await _localStoreImpl.getListModulos();
    listaModulo.value = list;
  }

  // =============================================================
  // 📦 CARGA DE MÓDULOS
  // =============================================================

  Future<void> cargarDatosLista() async {
    try {
      peticionServerState(true);
      listaModulo.clear();

      listaModulo.value = await _apiModulosRepository.buscaListaModulos();

      if (listaModulo.isEmpty) {
        await _cargarModulosOffline();
        return;
      }

      await _localStoreImpl.setDatosListaModulos(listModulos: listaModulo);
    } on ServerException {
      await _cargarModulosOffline();
    } finally {
      peticionServerState(false);
    }
  }

  // =============================================================
  // 🧍‍♂️ PERMISOS Y ALERTAS
  // =============================================================

  Future<void> consultaPermisosPolicia() async {
    try {
      final idGenUsuario = await _localStoreImpl.getIdUser();
      if (idGenUsuario == 0)
        return;
      peticionServerState(true);
      listaPermiso.value = await _apiAlertaViolenciaRepository.consultaPermisosPolicia(idGenUsuario);
      if (listaPermiso[0].servicio=="N"){
        AppConfig.servicio.value=false;
      }
      await generaToken();
    } on ServerException {
      await _cargarModulosOffline();
    } finally {
      peticionServerState(false);
    }
  }

  Future<void> consultaAlertasUsuarioNumero() async {
    try {
      final idGenPersona = await _localStoreImpl.getIdUser();
      peticionServerState(true);
      listaAlertasUsuario.value =
      await _apiAlertaViolenciaRepository.consultaListaAlertasUsuario(idGenPersona);
    } on ServerException {
      // manejar errores sin interrumpir
    } finally {
      peticionServerState(false);
    }
  }

  // =============================================================
  // 📡 GPS Y UBICACIÓN
  // =============================================================

  Future<void> verificarGps() async {
    final gpsActivo = await gpsController.verificarGPS();
    if (!gpsActivo) return;

    gpsController.iniciarSeguimiento();

    if (AppConfig.ubicacion.value.latitude == 0.0) {
      DialogosAwesome.getInformation(
        descripcion: "Las coordenadas aún no están listas. Vuelva a intentar.",
      );
      return;
    }

    gpsController.cancelarSeguimiento();

    final data = {
      "id": "0",
      "imagen": listaModulo.isNotEmpty ? listaModulo[0].imgBase64 : "",
    };

    Get.toNamed(AppRoutes.MAPAUPC, parameters: data);
  }

  // =============================================================
  // 🔔 NOTIFICACIONES (FCM)
  // =============================================================

  /// Solicita permisos y genera el token de FCM
  Future<void> initPermisosNotificaciones() async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("✅ Permisos de notificación concedidos");
      await generaToken();
    } else {
      print("❌ Permisos de notificación denegados");
    }
  }

  /// Genera el token FCM y lo registra en el servidor
  Future<void> generaToken() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission();

      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        print("❌ Permisos de notificaciones no autorizados por el usuario.");
        return;
      }

      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) {
        print("⚠️ No se pudo obtener el token FCM.");
        return;
      }

      print("✅ TOKEN FCM: $token");

      if (listaPermiso.isNotEmpty) {
        final idDinUsuariosApp = listaPermiso[0].idDinUsuariosApp;
        await _apiAlertaViolenciaRepository.actualizaTokenUsuario(
          idDinUsuariosApp: idDinUsuariosApp,
          tokenNotificacion: token,
        );
      }
    } catch (e, s) {
      print("🚨 Error generando token FCM: $e\n$s");
    }
  }

  /// Inicializa recepción de notificaciones mientras la app está activa
  void _initNotificaciones() {
    final messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final titulo = message.notification?.title ?? "Notificación";
      final cuerpo = message.notification?.body ?? "Nuevo mensaje";
      final data = message.data;

      DialogosAwesome.getSucess(btnOkOnPress: (){
        Get.back();
        if (data["tipo"] == "NUEVO_EVENTO") {
          Get.toNamed(AppRoutes.DETALLEALERTAS, parameters: {
            "id": data["idEvento"].toString(),
          });
        }

      },
        title: titulo,
        descripcion: cuerpo,
      );

    });
  }
  Future<void> _verificaDatos() async {
    userPref.value = await _localStoreImpl.getDatosUsuario();
    acuerdo = await _localStoreImpl.getDatosAcuerdo();

    // 🔹 Carga la foto del usuario guardada
    final bytes = await _localStoreImpl.getFoto();
    if (bytes != null)
      fotoPerfilBytes.value = bytes;
  }

}
