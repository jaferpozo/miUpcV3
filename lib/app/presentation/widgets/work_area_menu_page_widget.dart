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
    required this.numNotificacion,
  });

  @override
  _WorkAreaMenuPageWidgetState createState() => _WorkAreaMenuPageWidgetState();
}

class _WorkAreaMenuPageWidgetState extends State<WorkAreaMenuPageWidget> {
  final GpsController gpsController = Get.find<GpsController>();
  final MenuPrincipalController menuController = Get.find<MenuPrincipalController>();
  final LocalStoreImpl _localStoreImpl = Get.find<LocalStoreImpl>();

  String ver = '';
  String estadoConex = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  _loadVersion() async {
    String _version = await UtilidadesUtil.getVersionCodeNameApp();
    setState(() => ver = _version);
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();
    Widget wgImgFondo = SingleChildScrollView(
      child: SizedBox(
        height: responsive.alto,
        width: responsive.ancho,
        child: Image.asset(
          widget.imgFondo ?? AppImages.imgFondo1,
          fit: BoxFit.cover,
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        key: _key,
        bottomNavigationBar: bannerInferior(responsive),
        drawer: _buildDrawer(context),
        appBar: getAppBar(),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  wgImgFondo,
                  Column(
                    children: [
                      if (widget.title.isNotEmpty)
                        Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: responsive.anchoP(7),
                            color: const Color(0xFF06245B),
                          ),
                        ),
                      if (widget.foto64 != null)
                        Column(
                          children: [
                            SizedBox(height: responsive.altoP(2.0)),
                            imgPerfilRedonda(size: 30, img: widget.foto64),
                            SizedBox(height: responsive.altoP(1.0)),
                            Text(
                              widget.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: responsive.anchoP(4.5),
                                color: Colors.black.withOpacity(0.8),
                              ),
                            ),
                            SizedBox(height: responsive.altoP(2)),
                          ],
                        ),
                      widget.contenido,
                    ],
                  ),
                  Obx(() => CargandoWidget(mostrar: widget.peticionServer.value)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =======================================================
  // 🔹 BANNER INFERIOR SOCIAL
  // =======================================================
  Widget bannerInferior(ResponsiveUtil responsive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey, Color(0xFF06245B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, -2)),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          socialIconButton(iconPath: AppImages.imgFacebook, onTap: launchURLFace),
          socialIconButton(iconPath: AppImages.imgTwitter, onTap: launchURLTwitter),
          socialIconButton(iconPath: AppImages.imgInstagran, onTap: launchURLInsta),
          socialIconButton(iconPath: AppImages.imgYoutube, onTap: launchURLYou),
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
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white30, width: 1),
        ),
        child: Image.asset(iconPath, width: 24, height: 24),
      ),
    );
  }

  // =======================================================
  // 🔹 APPBAR
  // =======================================================
  AppBar getAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF06245B), Colors.grey.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(AppImages.imgEdificio, height: 32),
          const SizedBox(width: 8),
          const Text(
            'MI UPC',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ],
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, size: 28, color: Colors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      actions: [
       /* if (widget.mostrarNotificacion)
          Obx(() {
            final int total = widget.numNotificacion.value;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none, size: 40),
                  color: Colors.white,
                  onPressed: () => Get.toNamed(AppRoutes.DETALLEALERTAS),
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
          }),*/
      ],
    );
  }

  // =======================================================
  // 🔹 DRAWER LATERAL
  // =======================================================
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

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
                colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.05)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.power_settings_new, color: Colors.redAccent),
                      onPressed: () => exit(0),
                    ),
                  ),

                  // 👇 FOTO Y DATOS REACTIVOS DESDE MenuPrincipalController
                  Obx(() {
                    final bytes = menuController.fotoPerfilBytes.value;
                    final nombre = menuController.userPref.value;

                    return Column(
                      children: [
                        CircleAvatar(
                          radius: responsive.altoP(10),
                          backgroundColor: Colors.grey[200],
                          backgroundImage: bytes != null ? MemoryImage(bytes) : null,
                          child: bytes == null
                              ? Icon(Icons.person, size: responsive.altoP(8), color: Colors.grey)
                              : null,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          nombre.isNotEmpty ? nombre : "Usuario",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: responsive.diagonalP(1.6),
                          ),
                        ),
                        FutureBuilder<String>(
                          future: _localStoreImpl.getDatosMail(),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.data ?? "email@dominio.com",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: responsive.diagonalP(1.2),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }),

                  // OPCIONES DE NAVEGACIÓN
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _drawerItem(Icons.home, "Inicio", () {
                          Get.offAllNamed(AppRoutes.SPLASH);
                        }),
                        _drawerItem(Icons.share, "Compartir App", () {
                          Share.share("https://play.google.com/store/apps/details?id=com.miupc");
                        }),
                        _drawerItem(Icons.person, "Registrar / Editar Datos", verificaTConexion),
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
                  Text('v$ver ${AppConfig.ambiente}',
                      style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      hoverColor: Colors.white24,
    );
  }

  // =======================================================
  // 🔹 GPS / CONEXIÓN / URLS
  // =======================================================
  verificarGps() async {
    bool verificarGps = await gpsController.verificarGPS();
    if (verificarGps) {
      gpsController.iniciarSeguimiento();
      if (!gpsController.ubicacionLista.value) {
        DialogosAwesome.getInformation(
            descripcion: "Las coordenadas aún no están listas. Intente nuevamente.");
      } else {
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
    } on SocketException {
      DialogosAwesome.getError(descripcion: 'No tiene conexión a Internet');
    }
  }

  static Future<void> launchURLFace() async =>
      launchUrl(Uri.parse('https://www.facebook.com/policia.ecuador'),
          mode: LaunchMode.inAppBrowserView);

  static Future<void> launchURLTwitter() async =>
      launchUrl(Uri.parse('https://twitter.com/PoliciaEcuador'),
          mode: LaunchMode.inAppBrowserView);

  static Future<void> launchURLInsta() async =>
      launchUrl(Uri.parse('https://www.instagram.com/policiaecuadoroficial'),
          mode: LaunchMode.inAppBrowserView);

  static Future<void> launchURLYou() async =>
      launchUrl(Uri.parse('https://www.youtube.com/user/policiaecuador2'),
          mode: LaunchMode.inAppBrowserView);

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
}
