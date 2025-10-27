part of '../custom_widgets.dart';

class ComboBusqueda<T> extends StatefulWidget {
  final String title;
  final ValueChanged<T?>? complete;
  final List<T> datos;
  final String hint;
  final String searchHint;
  final T? selectValue;
  final IconData? icon;
  final String? imgUrl;
  final bool showClearButton;
  final GlobalKey? openDropDownProgKey;
  final String? textSeleccioneUndato;
  final String? Function(T?)? validator;
  final String Function(T)? displayField;
  final void Function(T)? onChanged;

  const ComboBusqueda({
    Key? key,
    this.complete,
    required this.datos,
    this.title = '',
    this.hint = 'Seleccione...',
    required this.searchHint,
    this.selectValue,
    this.icon,
    this.showClearButton = true,
    this.openDropDownProgKey,
    this.textSeleccioneUndato,
    this.imgUrl,
    this.validator,
    this.displayField,
    this.onChanged,
  }) : super(key: key);

  @override
  _ComboBusquedaState<T> createState() => _ComboBusquedaState<T>();
}

class _ComboBusquedaState<T> extends State<ComboBusqueda<T>>
    with SingleTickerProviderStateMixin {
  late bool showX;
  final _userEditTextController = TextEditingController(text: '');
  T? _selectedValue;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    showX = false;
    _selectedValue = null; // 🔹 Inicia vacío
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _userEditTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Título del combo
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: responsive.diagonalP(1.9),
                color: const Color(0xFF06245B),
              ),
            ),
          ),

          // 🔹 Dropdown estilizado
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.white, Color(0xFFF7F9FC)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF195BA6).withOpacity(0.4),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: DropdownSearch<T>(
              key: widget.openDropDownProgKey,
              selectedItem: _selectedValue,
              compareFn: (item, selectedItem) => item == selectedItem,
              validator: widget.validator ??
                      (v) => v == null ? "Seleccione un ${widget.title}" : null,
              suffixProps: DropdownSuffixProps(
                clearButtonProps: ClearButtonProps(
                  isVisible: showX,
                  color: Colors.red,
                ),
              ),

              // ✅ Popup tipo menú (más estable en esta versión)
              popupProps: PopupProps.menu(
                fit: FlexFit.loose,
                constraints: const BoxConstraints(),
                showSearchBox: true,
                searchFieldProps: _getSearchPopup(),
                itemBuilder: (context, item, isSelected, _) =>
                    _customItemPopup(context, item, isSelected),
              ),

              // ✅ Fuente de datos correcta para 6.0.2
              items: (filter, infiniteScrollProps) => widget.datos,

              itemAsString: (item) =>
              (item != null && widget.displayField != null)
                  ? widget.displayField!(item)
                  : '',
              dropdownBuilder: (context, selectedItem) =>
                  _customDropDown(context, selectedItem),

              onChanged: (value) {
                setState(() => _selectedValue = value);
                widget.complete?.call(value);
                if (value != null) widget.onChanged?.call(value);
              },

              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(12),
                  border: InputBorder.none,
                ),
              ),
            )




          ),
        ],
      ),
    );
  }

  // ===================== 🔍 Campo de búsqueda =====================
  TextFieldProps _getSearchPopup() {
    return TextFieldProps(
      controller: _userEditTextController,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: Color(0xFF195BA6)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.close, color: Colors.redAccent),
          onPressed: () => Navigator.of(context).pop(),
        ),
        hintText: widget.searchHint,
        hintStyle: const TextStyle(color: Colors.black45),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF195BA6), width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ===================== ⬇️ Elemento seleccionado =====================
  Widget _customDropDown(BuildContext context, T? item) {
    final responsive = ResponsiveUtil();

    if (item == null || widget.displayField == null) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(widget.icon ?? Icons.list_alt_rounded,
                color: Colors.grey.shade500),
            const SizedBox(width: 8),
            Text(
              widget.textSeleccioneUndato ?? "",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: responsive.diagonalP(1.6),
              ),
            ),
          ],
        ),
      );
    }

    if (!showX) {
      Future.microtask(() {
        if (mounted) setState(() => showX = true);
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          Icon(widget.icon ?? Icons.event, color: const Color(0xFF195BA6)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.displayField!(item),
              style: TextStyle(
                fontSize: responsive.diagonalP(1.7),
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===================== 🧱 Diseño de ítem en popup =====================
  Widget _customItemPopup(BuildContext context, T? item, bool isSelected) {
    final responsive = ResponsiveUtil();
    if (item == null || widget.displayField == null) return const SizedBox();

    final text = widget.displayField!(item);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF195BA6).withOpacity(0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF195BA6)
              : Colors.grey.shade300,
          width: isSelected ? 1.4 : 1,
        ),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          isSelected ? Icons.check_circle : (widget.icon ?? Icons.event),
          color: isSelected
              ? const Color(0xFF195BA6)
              : Colors.grey.shade500,
        ),
        title: Text(
          text,
          style: TextStyle(
            fontSize: responsive.diagonalP(1.55),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
            color: isSelected
                ? const Color(0xFF06245B)
                : Colors.black87,
          ),
        ),
      ),
    );
  }
}
