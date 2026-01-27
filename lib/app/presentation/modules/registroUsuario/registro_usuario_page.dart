part of '../pages.dart';

class RegistroUsuarioPage extends GetView<RegistroUsuarioController> {
  const RegistroUsuarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _getAppBar('Registro de Usuario'),
      body: Obx(() => Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  _cardInstrucciones(),
                  const SizedBox(height: 10),
                  _formularioPrincipal(context),
                ],
              ),
            ),
          ),
          CargandoWidget(mostrar: controller.peticionServerState.value),
        ],
      )),
    );
  }

  // =====================================================
  // 🔹 AppBar con gradiente
  // =====================================================
  AppBar _getAppBar(String titleAppBar) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF06245B), Color(0xFF6c757d)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      title: Text(
        titleAppBar,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
        tooltip: 'Atrás',
        onPressed: () => Get.back(),
      ),
    );
  }

  // =====================================================
  // 🔹 Card de instrucciones
  // =====================================================
  Widget _cardInstrucciones() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              controller.datosCargados.value ? 'Editar Datos' : 'Instrucciones',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF06245B),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              controller.datosCargados.value
                  ? 'Puede actualizar su número de contacto, correo y foto de perfil.'
                  : 'Complete los siguientes datos para registrarse en la aplicación.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // 🔹 Formulario principal
  // =====================================================
  Widget _formularioPrincipal(BuildContext context) {
    final responsive = ResponsiveUtil();

    return Form(
      key: controller.formKeyNacional,
      child: Column(
        children: [
          _txtCedula(responsive),
          const SizedBox(height: 15),
          _txtNombresApellidos(responsive),
          const SizedBox(height: 10),
          _txtCelular(responsive),
          const SizedBox(height: 10),
          _txtCorreo(responsive),
          const SizedBox(height: 10),
          _wgFoto(responsive),
          _btnRegistrar(),
        ],
      ),
    );
  }

  // =====================================================
  // 🔹 Estilo base de Input
  // =====================================================
  InputDecoration _inputStyle(String label, String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: const Color(0xFF195ba6)),
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade100,
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF195ba6), width: 2),
        borderRadius: BorderRadius.circular(14),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(14),
      ),
      labelStyle: const TextStyle(color: Color(0xFF06245B)),
    );
  }

  // =====================================================
  // 🔹 Campos de texto
  // =====================================================
  Widget _txtCedula(ResponsiveUtil res) {
    return TextFormField(
      controller: controller.controllerCedula,
      readOnly: controller.datosCargados.value, // 🚫 No editable si ya existe
      maxLength: 10,
      keyboardType: TextInputType.number,
      decoration: _inputStyle('Cédula', 'Ingrese su número de cédula', Icons.badge)
          .copyWith(counterText: ""),
      validator: (v) =>
      (v == null || v.isEmpty) ? 'Ingrese su número de cédula' : null,
    );
  }

  Widget _txtNombresApellidos(ResponsiveUtil res) {
    return Column(
      children: [
        TextFormField(
          controller: controller.controllerPrimerNombre,
          readOnly: controller.datosCargados.value, // 🚫 bloqueado
          keyboardType: TextInputType.text,
          validator: (v) => v!.isEmpty ? 'Ingrese su primer nombre' : null,
          decoration:
          _inputStyle('Primer Nombre', 'Ingrese su primer nombre', Icons.person),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: res.anchoP(42),
              child: TextFormField(
                controller: controller.controllerApellido1,
                readOnly: controller.datosCargados.value,
                validator: (v) =>
                v!.isEmpty ? 'Ingrese su primer apellido' : null,
                decoration: _inputStyle('Apellido 1', 'Apellido 1', Icons.account_box),
              ),
            ),
            SizedBox(
              width: res.anchoP(42),
              child: TextFormField(
                controller: controller.controllerApellido2,
                readOnly: controller.datosCargados.value,
                validator: (v) =>
                v!.isEmpty ? 'Ingrese su segundo apellido' : null,
                decoration: _inputStyle(
                    'Apellido 2', 'Apellido 2', Icons.account_box_outlined),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _txtCelular(ResponsiveUtil res) {
    return TextFormField(
      maxLength: 10,
      controller: controller.controllerContacto,
      keyboardType: TextInputType.phone,
      decoration: _inputStyle('Número de Contacto', 'Ej: 0999999999', Icons.contact_phone),
      validator: (v) =>
      (v == null || v.isEmpty) ? 'Ingrese su número de contacto' : null,
    );
  }

  Widget _txtCorreo(ResponsiveUtil res) {
    return TextFormField(
      controller: controller.controllerCorreo,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => controller.emailValidator(value ?? ''),
      decoration: _inputStyle('Correo Electrónico', 'Ingrese su email', Icons.email_outlined),
    );
  }

  // =====================================================
  // 🔹 Foto de perfil
  // =====================================================
  Widget _wgFoto(ResponsiveUtil responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Foto de Perfil",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF06245B),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            controller.mGaleryCameraModel.value =
            await PhotoHelper.getDesingPictureGaleryOrCamera(
              initPeticion: (value) => controller.peticionServerState(value),
              titleImg: "Foto Perfil",
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade400),
              color: Colors.grey.shade100,
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_a_photo, color: Color(0xFF195ba6)),
                const SizedBox(width: 10),
                Text(
                  controller.mGaleryCameraModel.value == null &&
                      controller.fotoPerfilBytes.value == null
                      ? "Agregar Imagen"
                      : "Cambiar Imagen",
                  style: const TextStyle(color: Color(0xFF06245B)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        Obx(() {
          if (controller.mGaleryCameraModel.value != null) {
            return Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  controller.mGaleryCameraModel.value!.imageFile,
                  fit: BoxFit.cover,
                  height: responsive.altoP(20),
                  width: responsive.altoP(20),
                ),
              ),
            );
          } else if (controller.fotoPerfilBytes.value != null) {
            return Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  controller.fotoPerfilBytes.value!,
                  fit: BoxFit.cover,
                  height: responsive.altoP(20),
                  width: responsive.altoP(20),
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }),
      ],
    );
  }

  // =====================================================
  // 🔹 Botón de acción (Registrar o Guardar cambios)
  // =====================================================
  Widget _btnRegistrar() {
    final isEdit = controller.datosCargados.value;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF195ba6),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 6,
        ),
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        label: Text(
          isEdit ? 'GUARDAR CAMBIOS' : 'REGISTRARSE',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        onPressed: () => controller.registrarUsuario(),
      ),
    );
  }
}
