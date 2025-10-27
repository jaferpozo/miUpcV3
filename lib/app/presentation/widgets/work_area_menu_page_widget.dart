part of 'custom_widgets.dart';

class WorkAreaMenuPageWidget extends StatefulWidget {

  final RxBool peticionServer;
  final String title;
  final String name;
  final Widget contenido;
  final bool btnAtras;
  final VoidCallback? pantallaIrAtras;
  final Widget? widgetBtnFinal;
  final EdgeInsetsGeometry? paddin;
  final FloatingActionButtonLocation ubicacionBtnFinal;
  final imgFondo;
  final bool mostrarNotificacion;
  final double sizeTittle;
  final bool mostrarVersion;
  final foto64;
  final RxInt numNotificacion;

  const WorkAreaMenuPageWidget({
    required this.peticionServer,
    this.title = '',
    required this.mostrarNotificacion,
    required this.contenido,
    this.btnAtras = false,
    this.widgetBtnFinal,
    this.paddin,
    this.ubicacionBtnFinal = FloatingActionButtonLocation.centerFloat,
    this.imgFondo,
    this.sizeTittle = 0,
    this.mostrarVersion = false,
    this.pantallaIrAtras,
    this.name = '',
    this.foto64,
    required this.numNotificacion

  });

  @override
  _WorkAreaMenuPageWidgetState createState() => _WorkAreaMenuPageWidgetState();
}

class _WorkAreaMenuPageWidgetState extends State<WorkAreaMenuPageWidget> {
  GpsController gpsController = Get.find<GpsController>();
  Rx<Uint8List?> fotoPerfilBytes = Rx<Uint8List?>(null);
  String ver = '';
  String userPref = '';
  String mailPref = '';
  String acuerdoPref = '';
  String estadoConex = "";

  @override
  void initState() {
    // TODO: implement initState
    _verificaDatos();
    _loadVersion();
    _cargarFotoPerfil();
  }

  _loadVersion() async {
    String _version = await UtilidadesUtil.getVersionCodeNameApp();
    setState(() {
      ver = _version;
    });
  }

  final LocalStoreImpl _localStoreImpl =
  Get.find<LocalStoreImpl>();

  _verificaDatos() async {
    print("MENU: verificando datos");

    userPref = await _localStoreImpl.getDatosUsuario();
    acuerdoPref = await _localStoreImpl.getDatosAcuerdo();
    mailPref = await _localStoreImpl.getDatosMail();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();
    Widget wgImgFondo = SingleChildScrollView(child: Container(
      height: responsive.alto,
      width: responsive.ancho,
      child: Image.asset(
        widget.imgFondo ?? AppImages.imgFondo1,
        fit: BoxFit.cover,
      ),
    ),);

    return SafeArea(

        child:  Scaffold(
        bottomNavigationBar: bannerInferior(responsive),
        key: _key,
        drawer: _buildDrawer(context),
        appBar: getAppBar(),
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SafeArea(child: SingleChildScrollView(child: Stack(
              children: [
                wgImgFondo,
                Column(
                  children: [
                    widget.title == '' ? Container() : Text(
                      widget.title,
                      textAlign:
                      TextAlign.center,
                      style: TextStyle(
                        fontWeight:
                        FontWeight.bold,
                        fontSize: responsive.anchoP(7),
                        color: const Color(0xFF06245B),
                      ),
                    ),
                    widget.foto64 == null ? Container() : Container(
                      width: responsive.ancho,
                      margin: EdgeInsets.only(
                        top: responsive.altoP(2.0),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              AppConfig.radioBordecajas),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.blue.withOpacity(0.1),
                                blurRadius: 20)
                          ]),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            imgPerfilRedonda(size: 30, img: widget.foto64,),
                            SizedBox(height: responsive.altoP(1.0),),
                            Text(
                              widget.name,
                              textAlign:
                              TextAlign.center,
                              style: TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                  fontSize: responsive.anchoP(4.5),
                                  color: Colors.black
                                      .withOpacity(
                                      0.8)),
                            )
                          ],

                        ),

                      ),

                    ),
                    widget.foto64 == null ? Container() : SizedBox(
                      height: responsive.altoP(2),),
                    widget.contenido,

                  ],
                ),
                Obx(() =>
                    CargandoWidget(
                      mostrar: widget.peticionServer.value,
                    ))
              ],
            ),),)
        )));
  }

  Widget bannerInferior(ResponsiveUtil responsive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [   Colors.grey,Color(0xFF06245B),],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        color: Color(0xFF0A2A66), // mismo tono que AppBar o complementario
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          socialIconButton(
            iconPath: AppImages.imgFacebook,
            onTap: launchURLFace,
          ),
          socialIconButton(
            iconPath: AppImages.imgTwitter,
            onTap: launchURLTwitter,
          ),
          socialIconButton(
            iconPath: AppImages.imgInstagran,
            onTap: launchURLInsta,
          ),
          socialIconButton(
            iconPath: AppImages.imgYoutube,
            onTap: launchURLYou,
          ),
        ],
      ),
    );
  }

  Widget socialIconButton({
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white30, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Image.asset(
          iconPath,
          width: 24,
          height: 24,

        ),
      ),
    );
  }


  AppBar getAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [  Color(0xFF06245B), Colors.grey.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AppImages.imgEdificio,
            height: 32,
          ),
          const SizedBox(width: 8),
          const Text(
            'MI UPC',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu, size: 28),
            color: Colors.white,
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
      actions: [
        if (widget.mostrarNotificacion)
          Obx(() {
            final int total = widget.numNotificacion.value;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none, size: 28),
                  color: Colors.white,
                  onPressed: () {
                    // 👇 Navega al detalle de alertas
                    Get.toNamed(AppRoutes.DETALLEALERTAS);
                  },
                ),
                if (total > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                      child: Center(
                        child: Text(
                          total.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),

        if (widget.btnAtras && widget.pantallaIrAtras != null)
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 24),
            color: Colors.white,
            onPressed: widget.pantallaIrAtras,
          ),
      ],


      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
    );
  }


  // Drawer
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final Color primary = Colors.white;
  final Color active = Colors.grey.shade800;
  final Color divider = Colors.grey.shade600;

  Widget _buildDrawer(BuildContext context) {
    final responsive = ResponsiveUtil();

    return ClipRRect(
      borderRadius: const BorderRadius.horizontal(right: Radius.circular(30)),
      child: Drawer(
        backgroundColor: Colors.transparent,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0.05),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // CERRAR SESIÓN
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.power_settings_new, color: Colors.redAccent),
                      onPressed: () => exit(0),
                    ),
                  ),

                  // AVATAR & DATOS
                  Obx(() {
                    final bytes = fotoPerfilBytes.value;
                    return Column(
                      children: [
                        CircleAvatar(
                          radius: responsive.altoP(10),
                          backgroundColor: Colors.grey[200],
                          backgroundImage:
                          bytes != null ? MemoryImage(bytes) : null,
                          child: bytes == null
                              ? Icon(Icons.person, size: responsive.altoP(8), color: Colors.grey)
                              : null,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          userPref.isNotEmpty ? userPref : "Usuario",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: responsive.diagonalP(1.6),
                          ),
                        ),
                        Text(
                          mailPref.isNotEmpty ? mailPref : "email@dominio.com",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: responsive.diagonalP(1.2),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }),

                  // OPCIONES DE NAVEGACIÓN
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _drawerItem(Icons.home, "Inicio", () {
                          Get.offAllNamed(AppRoutes.SPLASH);
                        }),
                        _drawerItem(Icons.share, "Compartir App", () {
                          Share.share("https://play.google.com/store/...");
                        }),
                        _drawerItem(Icons.person,
                            userPref.isEmpty ? "Registrar Usuario" : "Cambiar Datos",
                            verificaTConexion
                        ),
                      ],
                    ),
                  ),

                  // SOCIAL + VERSIÓN
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        socialIconButtonD(AppImages.imgFacebook, launchURLFace),
                        socialIconButtonD(AppImages.imgTwitter, launchURLTwitter),
                        socialIconButtonD(AppImages.imgInstagran, launchURLInsta),
                        socialIconButtonD(AppImages.imgYoutube, launchURLYou),
                      ],
                    ),
                  ),
                  Text(
                    'v$ver ${AppConfig.ambiente}',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget socialIconButtonD(String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Image.asset(assetPath),
      ),
    );
  }
  Widget _drawerItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      hoverColor: Colors.white24,
    );
  }
  verificarGps() async {
    //se verifica si el GPS del dispositivo seta activo y tiene permisos
    bool verificarGps = await gpsController.verificarGPS();
    if (verificarGps) {
      gpsController.iniciarSeguimiento();
      // iniciarSeguimiento1();
      if (!gpsController.ubicacionLista.value) {
        DialogosAwesome.getInformation(
            descripcion: "Las coordenas aun no estan lista vuelva a intentar");
      }else{
      /*  if (acuerdoPref=="Aceptado"){

          Get.toNamed(AppRoutes.REGISTROUSUARIO);
        }else{
          Get.toNamed(AppRoutes.ACUERDO);
        }*/
        Get.toNamed(AppRoutes.REGISTROUSUARIO);
      }
    }
  }

  verificaTConexion() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        estadoConex = 'S';
        verificarGps();

      }
    } on SocketException catch (_) {
    DialogosAwesome.getError(descripcion: 'No tiene conexión a Internet');
    }
  }
  static Future<void> launchURLFace() async {
    final url = Uri.parse('https://www.facebook.com/policia.ecuador');
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }
  static Future<void>  launchURLTwitter() async {
    final url = Uri.parse('https://twitter.com/PoliciaEcuador');
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }

  static Future<void>  launchURLInsta() async {
    final url = Uri.parse('https://www.instagram.com/policiaecuadoroficial');
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }

  static Future<void>  launchURLYou() async {
    final url = Uri.parse('https://www.youtube.com/user/policiaecuador2');
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _cargarFotoPerfil() async {
    final bytes = await _localStoreImpl.getFoto();
    if (bytes != null) {
      fotoPerfilBytes.value = bytes;
    }
  }
}


