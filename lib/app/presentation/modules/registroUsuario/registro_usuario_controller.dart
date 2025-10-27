part of '../controllers.dart';

class RegistroUsuarioController extends GetxController {
  final RegistroUsuarioRepository _apiRegistroUsuarioRepository =
      Get.find<RegistroUsuarioRepository>();

  final GpsController gpsController = Get.find<GpsController>();
  final LocalStoreImpl _LocalStoreImpl = Get.find<LocalStoreImpl>();
  Rx<GaleryCameraModel?> mGaleryCameraModel = Rx<GaleryCameraModel?>(null);
  RxBool cedulaLista = false.obs;
  String imeiCell = '';
  bool cargarDatos = true;
  RxBool peticionServerState = false.obs;
  bool segundoNombre = false;

  //variable para que solo carge una vez los datos
  bool peticionServer = false;
  bool chk = false;
  bool chk1 = false;

  String nombresExt = '';
  RxBool visibilityTag = false.obs;
  RxBool visibilityObs = false.obs;
  String tConexion = 'MOVIL';

  String modeloCelular = '';
  String SSID = 'MOVIL';
  String tipoUsuario = 'NACIONAL';
  String latitud = '';
  String longitud = '';
  String estadoConex = 'N';
  String validaMail = 'N';
  Geolocator geolocator = Geolocator();

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  var controllerPrimerNombre = new TextEditingController();
  var controllerPrimerNombre2 = new TextEditingController();
  var controllerApellido1 = new TextEditingController();
  var controllerApellido2 = new TextEditingController();
  var controllerCedula = new TextEditingController();
  var controllerContacto = new TextEditingController();
  var controllerCorreo = new TextEditingController();

  var controllerPrimerNombreExt = new TextEditingController();
  var controllerPrimerNombre2Ext = new TextEditingController();
  var controllerApellido1Ext = new TextEditingController();
  var controllerApellido2Ext = new TextEditingController();
  var controllerCedulaExt = new TextEditingController();
  var controllerContactoExt = new TextEditingController();
  var controllerCorreoExt = new TextEditingController();
  final myControllerCedula = TextEditingController();
  final myControllerCedulaText = TextEditingController();
  final myControllerBoton = TextEditingController();

  final formKeyNacional = GlobalKey<FormState>();
  final formKeyExtra = GlobalKey<FormState>();
  double latitudMiUbicacion = 0.0, longitudMiUbicacion = 0.0;
  DeviceInfo? deviceInfo;
  Rx<Uint8List?> fotoPerfilBytes = Rx<Uint8List?>(null);

  @override
  void onInit() {
    getTelephonyInfo();
    getImei();
    initPlatformDevice();

    super.onInit();
  }

  @override
  void onReady() {
    // TODO: Donde la vista ya se presento
    _init();
  }

  _init() async {
    print(Get.deviceLocale.toString());
  }

  Future<void> getImei() async {
    String platformImei;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      try {
        platformImei = await androidInfo.id;
      } on Exception catch (_) {
        platformImei = 'Failed to get platform version.';
      }
      imeiCell = platformImei;
    }
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      try {
        platformImei = await iosDeviceInfo.systemName;
      } on Exception catch (_) {
        platformImei = 'Failed to get platform version.';
      }
      imeiCell = platformImei;
    }
  }

  String? emailValidator(String value) {
    if (!value.contains('@')) {
      validaMail = "N";
    } else {
      validaMail = "S";
    }
  }

  Future<void> getTelephonyInfo() async {
    tConexion = "none";
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      tConexion = "Mobile Data";
    } else if (connectivityResult == ConnectivityResult.wifi) {
      tConexion = "Wifi";
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      tConexion = "Ethernet";
    } else if (connectivityResult == ConnectivityResult.bluetooth) {
      tConexion = "Bluetooth Data connection";
    } else {
      tConexion = "none";
    }

    SSID = (await NetworkInfo().getWifiName())!;
  }

  Future<void> initPlatformDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        modeloCelular = '${androidInfo.manufacturer}-${androidInfo.model}';
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        modeloCelular =
            '${iosInfo.utsname.machine}-${iosInfo.utsname.version}}';
      }
    } catch (e) {
      print('Error: Failed to get platform version.');
    }
  }





  Future<void> registrarUsuario() async {
    try {
      peticionServerState(true);

      if (controllerCorreo.text == '') {
        DialogosAwesome.getError(
          descripcion: 'Verifique que todos los campos tengan datos',
        );
        peticionServerState(false);
        return;
      }
      emailValidator(controllerCorreo.text);
      if (validaMail == "N") {
        DialogosAwesome.getError(descripcion: 'mail no valido');
        return;
      }
      if ((controllerApellido1.text == '') ||
          (controllerApellido2.text == '') ||
          (controllerPrimerNombre.text == '') ||
          (controllerContacto.text == '') ||
          (controllerCorreo.text == '')) {
        DialogosAwesome.getError(
          descripcion: 'Verifique que todos los campos tengan datos',
        );
        peticionServerState(false);
        return;
      } else {
        peticionServerState(true);

        String ip= await DeviceInfo.getIp;
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
        if (splitted[0] == 'true') {
          _LocalStoreImpl.setTelefono(controllerContacto.text);
          _LocalStoreImpl.setDatosUsuario(splitted[1]);
          _LocalStoreImpl.setIdUser(int.parse(splitted[2]));
          _LocalStoreImpl.setDatosMail(controllerCorreo.text);


          // 1️⃣ Lee los bytes del archivo temporal
          final bytes = await mGaleryCameraModel.value?.imageFile.readAsBytes();
          if(bytes!=null){
            // 2️⃣ Guarda en SharedPreferences (Base64)
            await _LocalStoreImpl.setFoto(bytes);
            // 3️⃣ Actualiza el observable para UI
            fotoPerfilBytes.value = bytes;
          }


          DialogosAwesome.getSucess(
            descripcion: "Se ha registrado existosamente su usuario.",
            title: 'Mi Upc',
            btnOkOnPress: () {
              Get.offAllNamed(AppRoutes.MENU);
            },
          );
        } else {
          DialogosAwesome.getError(
            descripcion: mensaje,
            title: 'Mi Upc',
            btnOkOnPress: () {
            },
          );
          peticionServerState(false);
        }

        peticionServerState(false);
      }
    } on ServerException catch (e) {
      peticionServerState(false);
      DialogosAwesome.getError(descripcion: e.cause);
    }
  }
}
