part of '../pages.dart';

class AlertasDelitosPage extends GetView<AlertasDelitosController> {
  const AlertasDelitosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WorkAreaItemsPageWidget(
      titleAppBar: controller.nombreModulo,
      peticionServer: controller.peticionServerState,
      contenido: getContenido(),
      foto64: controller.imagenModulo,
      btnAtras: true,
    );
  }

  Widget getContenido() {
    final responsive = ResponsiveUtil();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: responsive.anchoP(3),
        vertical: responsive.altoP(1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ConnectionStatusBanner(
            status: controller.status,
            onInit: controller.connectionStatusController,
          ),
          _headerTecnico(responsive),
          SizedBox(height: responsive.altoP(0.6)),
          _formCard(responsive),
          SizedBox(height: responsive.altoP(2.0)),
          _btnGuardar(responsive),
          SizedBox(height: responsive.altoP(2.5)),
        ],
      ),
    );
  }

  Widget _headerTecnico(ResponsiveUtil responsive) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF195BA6),
            Color(0xFF0A2E5C),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(responsive.anchoP(4)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.14),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white24),
              ),
              child: const Icon(
                Icons.shield_outlined,
                color: Colors.white,
                size: 30,
              ),
            ),
            SizedBox(width: responsive.anchoP(3)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Registro de alerta ciudadana",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.diagonalP(2.0),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Complete la información del evento para generar el registro ",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.92),
                      fontSize: responsive.diagonalP(1.45),
                      height: 1.35,
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formCard(ResponsiveUtil responsive) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(responsive.anchoP(4)),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle(
                icon: Icons.assignment_outlined,
                title: "Datos del evento",
                subtitle:
                "Seleccione el tipo de evento y complete la información.",
                responsive: responsive,
              ),
              SizedBox(height: responsive.altoP(1.8)),
              Obx(() {
                if (controller.cargandoEventosApi.value) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  );
                }

                return ComboBusqueda<CatalogoModel>(
                  title: "Tipo de evento",
                  selectValue: controller.idEventoApiSeleccionado.value == 0
                      ? null
                      : controller.listEventosApi.firstWhereOrNull(
                        (c) => c.id == controller.idEventoApiSeleccionado.value,
                  ),
                  datos: controller.listEventosApi,
                  displayField: (item) => item.descripcion,
                  searchHint: "Seleccione el tipo de evento",
                  textSeleccioneUndato: "Seleccione un evento",
                  complete: (value) {
                    if (value != null) {
                      controller.seleccionarEventoCatalogo(value);
                    }
                  },
                );
              }),
              SizedBox(height: responsive.altoP(1.7)),
              _labelCampo("Descripción / observación", responsive),
              const SizedBox(height: 8),
              Container(
                decoration: _inputDecorationBox(),
                child: ContadorTextArea(
                  maxLength: 250,
                  controller: controller.descripcionController,
                  onChanged: (texto) {},
                ),
              ),
              SizedBox(height: responsive.altoP(1.7)),
              _labelCampo("Referencia del lugar", responsive),
              const SizedBox(height: 8),
              _textFieldElegant(
                controller: controller.referenciaController,
                hint: "Ej.: Calles Japón y Eloy Alfaro, frente a farmacia",
                icon: Icons.place_outlined,
                maxLines: 2,
              ),
              SizedBox(height: responsive.altoP(2.0)),
              _sectionTitle(
                icon: Icons.touch_app,
                title: "Ubicación de la evento",
                subtitle:
                "Toque el mapa para seleccionar la ubicación exacta de la evento.",
                responsive: responsive,
              ),
              Obx(() {
                final lat = controller.latitudEvento.value == 0.0
                    ? (controller.latitudDispositivo.value != 0.0
                    ? controller.latitudDispositivo.value
                    : -0.1968769)
                    : controller.latitudEvento.value;

                final lng = controller.longitudEvento.value == 0.0
                    ? (controller.longitudDispositivo.value != 0.0
                    ? controller.longitudDispositivo.value
                    : -78.511301)
                    : controller.longitudEvento.value;

                return SeleccionMapaEventoWidget(
                  latInicial: lat,
                  lngInicial: lng,
                  onUbicacionSeleccionada: (latitud, longitud) {
                    controller.actualizarUbicacionEvento(latitud, longitud);
                  },
                );
              }),
              SizedBox(height: responsive.altoP(1.2)),
             // _panelCoordenadasSeleccionadas(responsive),
            //  SizedBox(height: responsive.altoP(2.0)),
              _sectionTitle(
                icon: Icons.person_outline_rounded,
                title: "Datos de contacto",
                subtitle:
                "Estos campos permiten complementar el reporte y facilitan la gestión del evento.",
                responsive: responsive,
              ),
              SizedBox(height: responsive.altoP(1.6)),
              _labelCampo("Seudónimo / nombre referencial", responsive),
              const SizedBox(height: 8),
              _textFieldElegant(
                controller: controller.seudonimoController,
                hint: "Ej.: Vecino_Alerta",
                icon: Icons.badge_outlined,
              ),
              SizedBox(height: responsive.altoP(1.5)),
              _labelCampo("Número telefónico", responsive),
              const SizedBox(height: 8),
              _textFieldElegant(
                controller: controller.telefonoController,
                hint: "Ej.: 0999999999",
                icon: Icons.phone_android_outlined,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: responsive.altoP(1.5)),
              _labelCampo("Correo electrónico", responsive),
              const SizedBox(height: 8),
              _textFieldElegant(
                controller: controller.correoController,
                hint: "Ej.: usuario@correo.com",
                icon: Icons.alternate_email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
             // SizedBox(height: responsive.altoP(1.8)),
              //_panelInformativoEstado(responsive),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle({
    required IconData icon,
    required String title,
    required String subtitle,
    required ResponsiveUtil responsive,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2EAF4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: const Color(0xFF195BA6).withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF195BA6), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF0A2E5C),
                    fontWeight: FontWeight.w800,
                    fontSize: responsive.diagonalP(1.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.blueGrey.shade700,
                    fontSize: responsive.diagonalP(1.35),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _labelCampo(String text, ResponsiveUtil responsive) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: responsive.diagonalP(1.55),
        color: const Color(0xFF0A2E5C),
      ),
    );
  }

  BoxDecoration _inputDecorationBox() {
    return BoxDecoration(
      color: const Color(0xFFF9FBFD),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFD7E3F1)),
    );
  }

  Widget _textFieldElegant({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      decoration: _inputDecorationBox(),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(
          color: Color(0xFF243447),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.blueGrey.shade400),
          prefixIcon: Icon(icon, color: const Color(0xFF195BA6)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _panelCoordenadasSeleccionadas(ResponsiveUtil responsive) {
    return Obx(() {
      final lat = controller.latitudEvento.value;
      final lng = controller.longitudEvento.value;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAFE),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD6E4F3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF195BA6).withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.my_location_rounded,
                color: Color(0xFF195BA6),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Latitud evento: ${lat.toStringAsFixed(7)}\nLongitud evento: ${lng.toStringAsFixed(7)}',
                style: TextStyle(
                  fontSize: responsive.diagonalP(1.35),
                  color: const Color(0xFF0A2E5C),
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _panelInformativoEstado(ResponsiveUtil responsive) {
    return Obx(() {
      final online = controller.status.value == ConnectionStatus.online;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: online
              ? const Color(0xFFEAF7EE)
              : const Color(0xFFFFF4E8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: online
                ? const Color(0xFFB8DFC2)
                : const Color(0xFFF2D0A4),
          ),
        ),
        child: Row(
          children: [
            Icon(
              online ? Icons.wifi_tethering : Icons.wifi_off_rounded,
              color: online
                  ? const Color(0xFF2E7D32)
                  : const Color(0xFFC47A12),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                online
                    ? "Conexión activa. El evento será enviado al servidor institucional."
                    : "Sin conexión. Verifique internet antes de realizar el registro.",
                style: TextStyle(
                  color: online
                      ? const Color(0xFF1E5F2E)
                      : const Color(0xFF9A5B00),
                  fontWeight: FontWeight.w600,
                  fontSize: responsive.diagonalP(1.35),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _btnGuardar(ResponsiveUtil responsive) {
    return Obx(() {
      final online = controller.status.value == ConnectionStatus.online;
      final isLoading = controller.creandoEvento.value;
      final isPressed = controller.btnPressed.value;

      return GestureDetector(
        onTapDown: (_) => controller.btnPressed.value = true,
        onTapUp: (_) async {
          await Future.delayed(const Duration(milliseconds: 90));
          controller.btnPressed.value = false;

          if (isLoading) return;

          if (!online) {
            DialogosAwesome.getError(
              descripcion:
              "No tiene conexión a internet para realizar el registro.",
            );
            return;
          }

          await controller.crearEvento();
        },
        onTapCancel: () => controller.btnPressed.value = false,
        child: AnimatedScale(
          scale: isPressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isLoading
                    ? [
                  Colors.blueGrey,
                  Colors.blueGrey.shade700,
                ]
                    : const [
                  Color(0xFF195BA6),
                  Color(0xFF0A2E5C),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isPressed ? 0.12 : 0.22),
                  blurRadius: isPressed ? 6 : 14,
                  offset: Offset(0, isPressed ? 2 : 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading) ...[
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.6,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                ] else ...[
                  const Icon(
                    Icons.save_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                ],
                Text(
                  isLoading ? "REGISTRANDO EVENTO..." : "GUARDAR EVENTO",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: responsive.diagonalP(1.7),
                    letterSpacing: 0.7,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
