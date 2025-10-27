part of '../pages.dart';

class RegistroUsuarioPage extends GetView<RegistroUsuarioController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegistroUsuarioController>(
      builder: (_) => getContenido(context),
    );
  }

  // ===================== 🌐 CONTENIDO PRINCIPAL =====================
  Widget getContenido(context) {
    final responsive = ResponsiveUtil();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: getAppBar('Registro de Usuario'),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 2),
                      child: Column(
                        children: [
                          // 🧭 Encabezado
                          Text(
                            'Instrucciones',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF06245B),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Por favor complete los siguientes datos para continuar',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          getContenidonacional(responsive),
                          const SizedBox(height: 5),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(()=>CargandoWidget(mostrar: controller.peticionServerState.value)),
        ],
      ),
    );
  }

  // ===================== 🧾 FORMULARIO PRINCIPAL =====================
  Widget getContenidonacional(ResponsiveUtil responsive) {
    return Form(
      key: controller.formKeyNacional,
      child: Column(
        children: [
          _TxtCedula(responsive),
          const SizedBox(height: 15),
          Obx(() => controller.cedulaLista.isTrue
              ? getCampos(responsive)
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  // ===================== 🧭 APP BAR =====================
  AppBar getAppBar(String titleAppBar) {
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
        textAlign: TextAlign.center,
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

  // ===================== 📋 CAMPOS DEL FORMULARIO =====================
  Widget getCampos(ResponsiveUtil responsive) {
    return Column(
      children: [
        _TxtPrimerNombre(responsive),
        const SizedBox(height: 10),
        controller.segundoNombre
            ? _TxtPrimerNombre2(responsive)
            : const SizedBox.shrink(),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _TxtPrimerApellido1(responsive),
            _TxtPrimerApellido2(responsive),
          ],
        ),
        const SizedBox(height: 10),
        _TxtCelular(responsive),
        const SizedBox(height: 10),
        _TxtMail(responsive),
        const SizedBox(height: 10),
        wgFoto(responsive),
        _btnRegistrar(),
      ],
    );
  }

  // ===================== 🧩 CAMPOS DE TEXTO =====================
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

  Widget _TxtCedula(ResponsiveUtil res) {
    return TextFormField(
      onChanged: (value) {
        if (value.length == 10) {
          controller.controllerCedula.text = value;
          controller.cedulaLista.value = true;
        } else {
          controller.cedulaLista.value = false;
        }
      },
      maxLength: 10,
      controller: controller.controllerCedula,
      keyboardType: TextInputType.number,
      decoration: _inputStyle(
        'Cédula',
        'Ingrese su número de cédula',
        Icons.badge,
      ).copyWith(counterText: ""),
    );
  }

  Widget _TxtPrimerNombre(ResponsiveUtil res) {
    return TextFormField(
      controller: controller.controllerPrimerNombre,
      keyboardType: TextInputType.text,
      validator: (v) =>
      v!.isEmpty ? 'Ingrese su Primer Nombre' : null,
      decoration: _inputStyle(
        'Primer Nombre',
        'Ingrese su primer nombre',
        Icons.person,
      ),
    );
  }

  Widget _TxtPrimerNombre2(ResponsiveUtil res) {
    return TextFormField(
      controller: controller.controllerPrimerNombre2,
      keyboardType: TextInputType.text,
      validator: (v) =>
      v!.isEmpty ? 'Ingrese su Segundo Nombre' : null,
      decoration: _inputStyle(
        'Segundo Nombre',
        'Ingrese su segundo nombre',
        Icons.person_outline,
      ),
    );
  }

  Widget _TxtPrimerApellido1(ResponsiveUtil res) {
    return SizedBox(
      width: res.anchoP(42),
      child: TextFormField(
        controller: controller.controllerApellido1,
        keyboardType: TextInputType.text,
        validator: (v) =>
        v!.isEmpty ? 'Ingrese su Primer Apellido' : null,
        decoration: _inputStyle('Apellido 1', 'Apellido 1', Icons.account_box),
      ),
    );
  }

  Widget _TxtPrimerApellido2(ResponsiveUtil res) {
    return SizedBox(
      width: res.anchoP(42),
      child: TextFormField(
        controller: controller.controllerApellido2,
        keyboardType: TextInputType.text,
        validator: (v) =>
        v!.isEmpty ? 'Ingrese su Segundo Apellido' : null,
        decoration:
        _inputStyle('Apellido 2', 'Apellido 2', Icons.account_box_outlined),
      ),
    );
  }

  Widget _TxtCelular(ResponsiveUtil res) {
    return TextFormField(
      controller: controller.controllerContacto,
      keyboardType: TextInputType.phone,
      decoration: _inputStyle(
        'Número de Contacto',
        'Ej: 0999999999',
        Icons.contact_phone,
      ),
    );
  }

  Widget _TxtMail(ResponsiveUtil res) {
    return TextFormField(
      controller: controller.controllerCorreo,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        controller.emailValidator(value!);
        return null;
      },
      decoration: _inputStyle(
        'Correo Electrónico',
        'Ingrese su email',
        Icons.email_outlined,
      ),
    );
  }

  // ===================== 🖼️ FOTO PERFIL =====================
  Widget wgFoto(ResponsiveUtil responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
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
                  controller.mGaleryCameraModel.value == null
                      ? "Agregar Imagen"
                      : "Cambiar Imagen",
                  style: const TextStyle(color: Color(0xFF06245B)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        Obx(
              () => controller.mGaleryCameraModel.value == null
              ? const SizedBox.shrink()
              : Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                controller.mGaleryCameraModel.value!.imageFile,
                fit: BoxFit.cover,
                height: responsive.altoP(20),
                width: responsive.altoP(20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===================== 🔘 BOTÓN REGISTRO =====================
  Widget _btnRegistrar() {
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
        label: const Text(
          'REGISTRARSE',
          style: TextStyle(
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
