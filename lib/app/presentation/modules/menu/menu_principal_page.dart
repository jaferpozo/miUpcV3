part of '../pages.dart';
class MenuPrincipalPage extends GetView<MenuPrincipalController> {
  const MenuPrincipalPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(()=>WorkAreaMenuPageWidget(
      btnAtras: false,
      pantallaIrAtras: () => Get.back(),
      peticionServer: controller.peticionServerState,
      numNotificacion: controller.listaAlertasUsuario.length.obs,
      contenido:
      controller.status.value == ConnectionStatus.online
          ? getContenido()
          : getContenido(), mostrarNotificacion: controller.listaPermiso.length>0,
    ));
  }

  Widget getContenido() {
    final responsive = ResponsiveUtil();
    return Stack(
      children: [
        // fondo...
        Column(
          children: [
            SizedBox(height: responsive.altoP(0.50)),
            getCabecera(responsive),
            SizedBox(height: responsive.altoP(5
            )),
            // la grilla ya está dentro de su propio Obx
            SizedBox(
              width: responsive.anchoP(88),
              height: responsive.altoP(68),
              child: getListaDatosModulos(), // sin Obx aquí tampoco
            ),
          ],
        ),
        ConnectionStatusBanner(
          status: controller.status,
          onInit: controller.connectionStatusController,
        ),
      ],
    );
  }

  Widget getListaDatosModulos() {
    final responsive = ResponsiveUtil();
    return Obx(() {
      final mods = controller.listaModulo;
      return GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
          horizontal: responsive.anchoP(4),
          vertical: responsive.altoP(2),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: responsive.anchoP(4),
          mainAxisSpacing: responsive.altoP(3),
          childAspectRatio: 0.9,
        ),
        itemCount: mods.length,
        itemBuilder: (context, i) {
          final m = mods[i];
          return ModuleCard(
            title: m.tituloModulo,
            base64Img: m.imgBase64.isEmpty ? null : m.imgBase64,
            onTap: () => muestraPantalla(i, context),
          );
        },
      );
    });
  }

  Widget getCabecera(ResponsiveUtil responsive) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 3),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF195ba6), // azul institucional
              Color(0xFF6c757d), // gris institucional
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🟦 Avatar circular con borde institucional
            Obx(() {
              final bytes = controller.fotoPerfilBytes.value;
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.9),
                    width: 0.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: responsive.altoP(2.5),
                  backgroundColor: Colors.white,
                  backgroundImage: bytes != null ? MemoryImage(bytes) : null,
                  child: bytes == null
                      ? Icon(
                    Icons.person,
                    size: responsive.altoP(4.5),
                    color: Colors.grey.shade500,
                  )
                      : null,
                ),
              );
            }),

            const SizedBox(width: 6),

            // 🧾 Texto dinámico
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                        () => Text(
                      controller.userPref.value.isNotEmpty
                          ? '👋 BIENVENID@ ${controller.userPref.value}'
                          : '👋 BIENVENID@',
                      style: TextStyle(
                        fontSize: responsive.diagonalP(1.3),
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.3,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 3,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // 📅 Fecha actual
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          color: Colors.white70, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Hoy es ${UtilidadesUtil.getFechaActual}',
                        style: TextStyle(
                          fontSize: responsive.diagonalP(1.35),
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.9),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  muestraPantalla(index, BuildContext ctx) async {
    if (index == 0) {
      if (controller.status == ConnectionStatus.online) {
        controller.verificarGps();
      } else {
        DialogosAwesome.getError(descripcion: "No tiene Conexión a Internet");
      }
    }
    if (index == 1) {
      if (controller.status == ConnectionStatus.online) {
        Map<String, String> data = {
          "id": "3",
          "imagen": controller.listaModulo[1].imgBase64,
          "nombreModulo": 'Violencia de Género',
        };
        Get.toNamed(AppRoutes.SERVICIOS, parameters: data);
      } else {
        DialogosAwesome.getError(
          descripcion: "No tiene Conexión a Internet para registrar un evento",
        );
      }
    }
    if (index == 2) {
      Map<String, String> data = {
        "id": "1",
        "imagen": controller.listaModulo[2].imgBase64,
        "nombreModulo": 'Servicio Policía Comunitaria',
      };
      Get.toNamed(AppRoutes.SERVICIOS, parameters: data);
    }
    if (index == 3) {
      Map<String, String> data = {
        "id": "2",
        "imagen": controller.listaModulo[3].imgBase64,
        "nombreModulo": 'Medidas de Autoprotección',
      };
      Get.toNamed(AppRoutes.SERVICIOS, parameters: data);
    }
  }
}
