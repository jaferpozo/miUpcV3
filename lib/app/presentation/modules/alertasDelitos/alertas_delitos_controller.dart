part of '../controllers.dart';

class AlertasDelitosController extends GetxController {
  final AlertasDelitosRepository _apiAlertasDelitosRepository = Get.find();
  final GpsController gpsController = Get.find<GpsController>();
  // ======================= ⚙️ ESTADOS ==========================
  final RxBool peticionServerState = false.obs;
  final Rx<Uint8List?> fotoPerfilBytes = Rx<Uint8List?>(null);
  final RxString userPref = ''.obs;
  final RxBool btnPressed = false.obs;
  final CheckInternetConnection internetChecker = CheckInternetConnection();
  late StreamSubscription connectionSubscription;
  final Rx<ConnectionStatus> status = ConnectionStatus.online.obs;
  final bool usarCatalogoLocalTemporal = true;
  String imeiCell = '';
  String modeloCelular = '';
  String tConexion = 'MOVIL';
  String SSID = 'MOVIL';
  String plataforma = 'Android';

  final formKey = GlobalKey<FormState>();

  /// Parámetros de pantalla
  final Map<String, String?> datosServicio = Get.parameters;
  String nombreModulo = '';
  String imagenModulo = '';

  /// Controllers formulario
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController referenciaController = TextEditingController();
  final TextEditingController seudonimoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController correoController = TextEditingController();

  /// Estado catálogo eventos
  final RxList<CatalogoModel> listEventosApi = <CatalogoModel>[].obs;
  final RxInt idEventoApiSeleccionado = 0.obs;
  final RxString nombreEventoApiSeleccionado = ''.obs;
  final RxBool cargandoEventosApi = false.obs;

  /// Estado creación evento
  final RxBool creandoEvento = false.obs;
  final RxString mensajeError = ''.obs;
  final Rxn<EventoEntity> eventoCreado = Rxn<EventoEntity>();

  /// Coordenadas
  final RxDouble latitudDispositivo = 0.0.obs;
  final RxDouble longitudDispositivo = 0.0.obs;
  final RxDouble latitudEvento = 0.0.obs;
  final RxDouble longitudEvento = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    imagenModulo = datosServicio['imagen']?.toString() ?? '';
    nombreModulo = datosServicio['nombreModulo']?.toString() ?? '';
    getImei();
    getTelephonyInfo();
    initPlatformDevice();
    connectionStatusController();
    consultaDatosCatalogoAlerta();
  }

  @override
  void onClose() {
    descripcionController.dispose();
    referenciaController.dispose();
    seudonimoController.dispose();
    telefonoController.dispose();
    correoController.dispose();
    connectionSubscription.cancel();
    internetChecker.close();
    super.onClose();
  }

  void connectionStatusController() {
    connectionSubscription =
        internetChecker.internetStatus().listen((newStatus) {
          status.value = newStatus;
        });
  }
  Future<void> consultaDatosCatalogoAlerta() async {
    try {
      listEventosApi.clear();
      cargandoEventosApi.value = true;

      if (usarCatalogoLocalTemporal) {
        final List<CatalogoModel> tiposEvento = [
          CatalogoModel(id: 1, descripcion: 'EXTORSIÓN'),
          CatalogoModel(id: 2, descripcion: 'SECUESTRO'),
          CatalogoModel(id: 3, descripcion: 'DROGAS'),
          CatalogoModel(id: 4, descripcion: 'OTRO'),
        ];

        listEventosApi.assignAll(tiposEvento);
        return;
      }

      final List<CatalogoModel> response =
      await _apiAlertasDelitosRepository.consultaCatalogos(92);

      listEventosApi.assignAll(response);
    } on ServerException catch (e) {
      DialogosAwesome.getError(descripcion: e.cause);
    } catch (e) {
      DialogosAwesome.getError(descripcion: e.toString());
    } finally {
      cargandoEventosApi.value = false;
    }
  }

  /// Consulta catálogo de tipos de evento
  Future<void> consultaDatosCatalogoAlertaApi() async {
    try {
      listEventosApi.clear();
      cargandoEventosApi.value = true;

      final List<CatalogoModel> response =
      await _apiAlertasDelitosRepository.consultaCatalogos(92);

      listEventosApi.assignAll(response);
    } on ServerException catch (e) {
      DialogosAwesome.getError(descripcion: e.cause);
    } catch (e) {
      DialogosAwesome.getError(descripcion: e.toString());
    } finally {
      cargandoEventosApi.value = false;
    }
  }

  /// Selección del catálogo
  void seleccionarEventoCatalogo(CatalogoModel item) {
    idEventoApiSeleccionado.value = item.id;
    nombreEventoApiSeleccionado.value = item.descripcion;
  }

  /// Verifica GPS y toma coordenadas actuales
  Future<bool> verificarGps() async {
    final bool gpsOk = await gpsController.verificarGPS();

    if (!gpsOk) return false;

    gpsController.iniciarSeguimiento();

    await Future.delayed(const Duration(seconds: 2));

    if (AppConfig.ubicacion.value.latitude == 0.0 &&
        AppConfig.ubicacion.value.longitude == 0.0) {
      gpsController.cancelarSeguimiento();

      DialogosAwesome.getInformationAceptar(
        btnOkOnPress: () {
          Get.back();
        },
        descripcion: "Las coordenadas aún no están listas, vuelva a intentar.",
      );
      return false;
    }
    latitudDispositivo.value = AppConfig.ubicacion.value.latitude;
    longitudDispositivo.value = AppConfig.ubicacion.value.longitude;

    /// Solo asigna la ubicación del evento si aún no fue seleccionada manualmente
    if (latitudEvento.value == 0.0 && longitudEvento.value == 0.0) {
      latitudEvento.value = AppConfig.ubicacion.value.latitude;
      longitudEvento.value = AppConfig.ubicacion.value.longitude;
    }


    gpsController.cancelarSeguimiento();
    return true;
  }

  bool validarFormulario() {
    if (idEventoApiSeleccionado.value == 0 ||
        nombreEventoApiSeleccionado.value.trim().isEmpty) {
      DialogosAwesome.getInformationAceptar(
        descripcion: "Debe seleccionar un tipo de evento.",
        btnOkOnPress: () => Get.back(),
      );
      return false;
    }

    if (descripcionController.text.trim().isEmpty) {
      DialogosAwesome.getInformationAceptar(
        descripcion: "Debe ingresar la descripción del evento.",
        btnOkOnPress: () => Get.back(),
      );
      return false;
    }

    if (referenciaController.text.trim().isEmpty) {
      DialogosAwesome.getInformationAceptar(
        descripcion: "Debe ingresar una referencia del lugar.",
        btnOkOnPress: () => Get.back(),
      );
      return false;
    }

    return true;
  }

  Future<bool> crearEvento() async {
    try {
      mensajeError.value = '';
      eventoCreado.value = null;

      if (status.value == ConnectionStatus.offline) {
        DialogosAwesome.getInformationAceptar(
          descripcion: "No tiene conexión a internet.",
          btnOkOnPress: () => Get.back(),
        );
        return false;
      }

      if (!validarFormulario()) {
        return false;
      }

      final bool gpsOk = await verificarGps();
      if (!gpsOk) {
        return false;
      }

      creandoEvento.value = true;
      final now = DateTime.now().toUtc();
      final deviceData = await DeviceNetworkHelper.getDeviceNetworkData();
      final EventoEntity evento = EventoEntity(
        idDispositivo: deviceData.idDispositivo,
        tipoEvento: nombreEventoApiSeleccionado.value.trim(),
        fechaEvento: now.toString(),
        descripcionEvento: descripcionController.text.trim(),
        referenciaLugar: referenciaController.text.trim(),
        latitudDispositivo: latitudDispositivo.value,
        longitudDispositivo: longitudDispositivo.value,
        latitudEvento: latitudEvento.value,
        longitudEvento: longitudEvento.value,
        nombreSeudonimo: seudonimoController.text.trim().isEmpty
            ? "Anónimo"
            : seudonimoController.text.trim(),
        numeroTelefono: telefonoController.text.trim(),
        correoElectronico: correoController.text.trim(),
        nombreArchivoRespaldo: null,
        direccionIp: "${deviceData.red} - ${deviceData.tipoRed}: ${deviceData.direccionIp}",
        agenteUsuario: "${plataforma} - ${modeloCelular}: ${deviceData.direccionIp}",
        estado: "pendiente",
        fechaCreacion: now.toString(),
        fechaActualizacion: now.toString(),
      );

      final EventoEntity response =
      await _apiAlertasDelitosRepository.crearEvento(evento);

      eventoCreado.value = response;

      DialogosAwesome.getSucess(
        descripcion: "Evento registrado correctamente. ID: ${response.id ?? 0}",
      );

      limpiarFormulario();
      return true;
    } on ServerException catch (e) {
      mensajeError.value = e.cause;
      DialogosAwesome.getError(descripcion: e.cause);
      return false;
    } catch (e) {
      mensajeError.value = e.toString();
      DialogosAwesome.getError(descripcion: e.toString());
      return false;
    } finally {
      creandoEvento.value = false;
    }
  }

  void limpiarFormulario() {
    descripcionController.clear();
    referenciaController.clear();
    seudonimoController.clear();
    telefonoController.clear();
    correoController.clear();

    idEventoApiSeleccionado.value = 0;
    nombreEventoApiSeleccionado.value = '';
    latitudDispositivo.value = 0.0;
    longitudDispositivo.value = 0.0;
    latitudEvento.value = 0.0;
    longitudEvento.value = 0.0;
  }
  void actualizarUbicacionEvento(double lat, double lng) {
    latitudEvento.value = lat;
    longitudEvento.value = lng;
  }
  void setUbicacionEventoDesdeDispositivo() {
    latitudEvento.value = latitudDispositivo.value;
    longitudEvento.value = longitudDispositivo.value;
  }
  // ==============================================================
  // 🔹 Funciones de sistema (IMEI, conexión, modelo)
  // ==============================================================
  Future<void> getImei() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        imeiCell = androidInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        imeiCell = iosInfo.identifierForVendor ?? "iOS";
      }
    } catch (_) {}
  }

  Future<void> getTelephonyInfo() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile) {
        tConexion = "Mobile Data";
      } else if (connectivityResult == ConnectivityResult.wifi) {
        tConexion = "Wifi";
      } else {
        tConexion = "none";
      }
      SSID = (await NetworkInfo().getWifiName()) ?? "none";
    } catch (_) {}
  }

  Future<void> initPlatformDevice() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        modeloCelular = '${androidInfo.manufacturer}-${androidInfo.model}';
        plataforma='Androd';
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        modeloCelular = '${iosInfo.utsname.machine}-${iosInfo.systemVersion}';
        plataforma='iOs';
      }
    } catch (e) {
      print('Error: Failed to get platform version.');
    }
  }
}
