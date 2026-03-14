part of '../controllers.dart';

class RegistroUsuarioController extends GetxController {
  final RegistroUsuarioRepository _apiRegistroUsuarioRepository =
  Get.find<RegistroUsuarioRepository>();
  final GpsController gpsController = Get.find<GpsController>();
  final LocalStoreImpl _LocalStoreImpl = Get.find<LocalStoreImpl>();

  // ==================== Variables de control ====================
  Rx<GaleryCameraModel?> mGaleryCameraModel = Rx<GaleryCameraModel?>(null);
  RxBool peticionServerState = false.obs;
  Rx<Uint8List?> fotoPerfilBytes = Rx<Uint8List?>(null);
  RxBool datosCargados = false.obs; // ✅ indica si hay datos guardados localmente
  RxBool cedulaLista = false.obs;

  String imeiCell = '';
  String modeloCelular = '';
  String tConexion = 'MOVIL';
  String SSID = 'MOVIL';
  String tipoUsuario = 'NACIONAL';
  String validaMail = 'N';
////////////PARA IMAGEN
  final Rxn<AdjuntoModel> adjuntoSeleccionado = Rxn<AdjuntoModel>();
  final RxBool cargandoAdjunto = false.obs;

  // ==================== Controladores de texto ====================
  final controllerPrimerNombre = TextEditingController();
  final controllerApellido1 = TextEditingController();
  final controllerApellido2 = TextEditingController();
  final controllerCedula = TextEditingController();
  final controllerContacto = TextEditingController();
  final controllerCorreo = TextEditingController();

  final formKeyNacional = GlobalKey<FormState>();
  DeviceInfo? deviceInfo;

  // ==============================================================
  // 🔹 CICLO DE VIDA
  // ==============================================================
  @override
  void onInit() {
    super.onInit();
    getTelephonyInfo();
    getImei();
    initPlatformDevice();
    _loadDatosLocales(); // ✅ Cargar datos del usuario si existen
  }

  @override
  void onReady() {
    _init();
    super.onReady();
  }

  _init() async {
    print("🌍 Idioma: ${Get.deviceLocale}");
  }

  // ==============================================================
  // 🔹 Cargar datos locales
  // ==============================================================
  Future<void> _loadDatosLocales() async {
    final data = await _LocalStoreImpl.getDatosUsuarioCompleto();
    if (data != null) {
      controllerPrimerNombre.text = data['nombre'] ?? '';
      controllerApellido1.text = data['apellido1'] ?? '';
      controllerApellido2.text = data['apellido2'] ?? '';
      controllerCedula.text = data['cedula'] ?? '';
      controllerContacto.text = data['telefono'] ?? '';
      controllerCorreo.text = data['correo'] ?? '';
      if (data['foto'] != null) {
        fotoPerfilBytes.value = base64Decode(data['foto']);
      }
      datosCargados.value = true;
      cedulaLista.value = true;
      print("✅ Datos cargados localmente desde SharedPreferences");
    }
  }

  // ==============================================================
  // 🔹 Guardar datos locales (nombre, apellidos, etc.)
  // ==============================================================
  Future<void> _guardarDatosLocales({Uint8List? fotoBytes}) async {
    await _LocalStoreImpl.setDatosUsuarioCompleto(
      nombre: controllerPrimerNombre.text,
      apellido1: controllerApellido1.text,
      apellido2: controllerApellido2.text,
      cedula: controllerCedula.text,
      telefono: controllerContacto.text,
      correo: controllerCorreo.text,
      foto: fotoBytes ?? fotoPerfilBytes.value,
    );
  }

  // ==============================================================
  // 🔹 Validar correo electrónico
  // ==============================================================
  String? emailValidator(String value) {
    if (!value.contains('@') || !value.contains('.')) {
      validaMail = "N";
      return "Correo inválido";
    } else {
      validaMail = "S";
      return null;
    }
  }

  // ==============================================================
// 🔹 Registrar usuario o actualizar datos
// ==============================================================
  Future<void> registrarUsuario() async {
    try {
      peticionServerState(true);

      // 🔸 Validar campos
      if (controllerCorreo.text.isEmpty ||
          controllerContacto.text.isEmpty ||
          controllerCedula.text.isEmpty) {
        DialogosAwesome.getError(
          descripcion: 'Verifique que todos los campos tengan datos',
          btnOkOnPress: () => Get.back(),
        );
        peticionServerState(false);
        return;
      }

      emailValidator(controllerCorreo.text);
      if (validaMail == "N") {
        DialogosAwesome.getError(
          descripcion: 'Correo electrónico no válido',
          btnOkOnPress: () => Get.back(),
        );
        peticionServerState(false);
        return;
      }

      // 🔹 Si es primera vez → registrar en servidor
      if (!datosCargados.value) {
        String ip = await DeviceInfo.getIp;
        String mensaje = await _apiRegistroUsuarioRepository.insertarUsuario(
          tipoUsuario: tipoUsuario,
          latitud: AppConfig.ubicacion.value.latitude,
          longitud: AppConfig.ubicacion.value.longitude,
          mail: controllerCorreo.text,
          fechaRegistro: MyDate.getFechaActual,
          tipoConexion: tConexion,
          ssIDConexion: SSID,
          numCelular: controllerContacto.text,
          versionAndroid: imeiCell,
          modeloCelular: modeloCelular,
          cedula: controllerCedula.text,
          ip: ip,
          primerApellido: controllerApellido1.text,
          primerNombre: controllerPrimerNombre.text,
          segundoApellido: controllerApellido2.text,
        );

        final splitted = mensaje.split('|');
        if (splitted.isNotEmpty && splitted[0] == 'true') {
          _LocalStoreImpl.setTelefono(controllerContacto.text);
          _LocalStoreImpl.setDatosUsuario(splitted[1]);
          _LocalStoreImpl.setIdUser(int.parse(splitted[2]));
          _LocalStoreImpl.setDatosMail(controllerCorreo.text);
        }
      }

      // 🔹 Guardar imagen y datos localmente
      final bytes = await mGaleryCameraModel.value?.imageFile.readAsBytes();
      if (bytes != null) {
        fotoPerfilBytes.value = bytes;
        await _LocalStoreImpl.setFoto(bytes); // ✅ Guarda la foto directamente
      }


      await _guardarDatosLocales(fotoBytes: bytes);

      peticionServerState(false);

      // 🔹 Éxito y redirección
      DialogosAwesome.getSucess(
        title: "Mi UPC",
        descripcion: datosCargados.value
            ? "Datos actualizados correctamente."
            : "Usuario registrado exitosamente.",
        btnOkOnPress: () async {
          datosCargados.value = true;
          await _LocalStoreImpl.setDatosUsuarioCompleto(
            nombre: controllerPrimerNombre.text,
            apellido1: controllerApellido1.text,
            apellido2: controllerApellido2.text,
            cedula: controllerCedula.text,
            telefono: controllerContacto.text,
            correo: controllerCorreo.text,
            foto: fotoPerfilBytes.value,
          );

          Get.offAllNamed(AppRoutes.MENU)?.then((_) async {
            final menuCtrl = Get.find<MenuPrincipalController>();
            await menuCtrl._verificaDatos();
            await menuCtrl._cargarFotoPerfil(); // ✅ recarga asegurada
          });

        },
      );

    } catch (e) {
      peticionServerState(false);
      DialogosAwesome.getError(
        descripcion: "Error al guardar datos: $e",
        btnOkOnPress: () => Get.back(),
      );
    }
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
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        modeloCelular = '${iosInfo.utsname.machine}-${iosInfo.systemVersion}';
      }
    } catch (e) {
      print('Error: Failed to get platform version.');
    }
  }
  Future<void> seleccionarAdjunto() async {
    try {
      cargandoAdjunto.value = true;

      final archivo = await FileAdjuntoHelper.seleccionarArchivo();

      if (archivo != null) {
        adjuntoSeleccionado.value = archivo;

        if (archivo.superaCincoMb) {
          DialogosAwesome.getInformationAceptar(
            descripcion:
            "El archivo seleccionado supera los 5 MB. Se recomienda conectarse a una red Wi-Fi para continuar con el envío.",
            btnOkOnPress: () => Get.back(),
          );
        }
      }
    } catch (e) {
      DialogosAwesome.getError(
        descripcion: "No fue posible seleccionar el archivo: $e",
      );
    } finally {
      cargandoAdjunto.value = false;
    }
  }

  void eliminarAdjunto() {
    adjuntoSeleccionado.value = null;
  }

}
