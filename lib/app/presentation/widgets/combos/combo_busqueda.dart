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
  State<ComboBusqueda<T>> createState() => _ComboBusquedaState<T>();
}

class _ComboBusquedaState<T> extends State<ComboBusqueda<T>>
    with SingleTickerProviderStateMixin {
  final TextEditingController _userEditTextController = TextEditingController();

  late T? _selectedValue;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  bool _isFocused = false;

  @override
  void initState() {
    super.initState();

    _selectedValue = widget.selectValue;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant ComboBusqueda<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectValue != oldWidget.selectValue) {
      _selectedValue = widget.selectValue;
    }
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
    final bool tieneValor = _selectedValue != null;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title.trim().isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: responsive.diagonalP(1.55),
                  color: const Color(0xFF0A2E5C),
                ),
              ),
            ),
          ],
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FBFD),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isFocused
                    ? const Color(0xFF195BA6)
                    : const Color(0xFFD7E3F1),
                width: _isFocused ? 1.8 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isFocused
                      ? const Color(0xFF195BA6).withOpacity(0.12)
                      : Colors.black.withOpacity(0.04),
                  blurRadius: _isFocused ? 10 : 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: DropdownSearch<T>(
                key: widget.openDropDownProgKey,
                selectedItem: _selectedValue,
                compareFn: (item, selectedItem) => item == selectedItem,
                validator: widget.validator ??
                        (v) => v == null
                        ? (widget.textSeleccioneUndato ??
                        "Seleccione un ${widget.title}")
                        : null,
                items: (filter, infiniteScrollProps) => widget.datos,
                itemAsString: (item) =>
                (item != null && widget.displayField != null)
                    ? widget.displayField!(item)
                    : '',
                onBeforePopupOpening: (selectedItem) async {
                  if (mounted) {
                    setState(() => _isFocused = true);
                  }
                  return true;
                },
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value;
                  });

                  widget.complete?.call(value);
                  if (value != null) {
                    widget.onChanged?.call(value);
                  }
                },
                suffixProps: DropdownSuffixProps(
                  dropdownButtonProps: DropdownButtonProps(
                    iconClosed: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: _isFocused
                          ? const Color(0xFF195BA6)
                          : Colors.blueGrey.shade400,
                      size: 26,
                    ),
                    iconOpened: const Icon(
                      Icons.keyboard_arrow_up_rounded,
                      color: Color(0xFF195BA6),
                      size: 26,
                    ),
                  ),
                  clearButtonProps: ClearButtonProps(
                    isVisible: widget.showClearButton && tieneValor,
                    icon: const Icon(
                      Icons.cancel_rounded,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                  ),
                ),
                popupProps: PopupProps.menu(
                  fit: FlexFit.loose,
                  showSearchBox: true,
                  menuProps: MenuProps(
                    backgroundColor: Colors.white,
                    elevation: 10,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  searchFieldProps: _getSearchPopup(),
                  emptyBuilder: (context, searchEntry) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 42,
                            color: Colors.blueGrey.shade300,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "No se encontraron resultados",
                            style: TextStyle(
                              color: Colors.blueGrey.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemBuilder: (context, item, isSelected, isDisabled) {
                    return _customItemPopup(context, item, isSelected);
                  },
                ),
                dropdownBuilder: (context, selectedItem) {
                  return _customDropDown(context, selectedItem);
                },
                decoratorProps: DropDownDecoratorProps(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextFieldProps _getSearchPopup() {
    return TextFieldProps(
      controller: _userEditTextController,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF7FAFD),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: Color(0xFF195BA6),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.redAccent),
          onPressed: () => Navigator.of(context).pop(),
        ),
        hintText: widget.searchHint,
        hintStyle: TextStyle(
          color: Colors.blueGrey.shade400,
          fontWeight: FontWeight.w500,
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD7E3F1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD7E3F1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF195BA6), width: 1.6),
        ),
      ),
    );
  }

  Widget _customDropDown(BuildContext context, T? item) {
    final responsive = ResponsiveUtil();

    if (item == null || widget.displayField == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 2),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (_isFocused
                    ? const Color(0xFF195BA6)
                    : const Color(0xFF195BA6))
                    .withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                widget.icon ?? Icons.list_alt_rounded,
                color: _isFocused
                    ? const Color(0xFF195BA6)
                    : Colors.blueGrey.shade400,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.textSeleccioneUndato ?? widget.hint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.blueGrey.shade500,
                  fontSize: responsive.diagonalP(1.48),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 2),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF195BA6).withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              widget.icon ?? Icons.check_circle_outline_rounded,
              color: const Color(0xFF195BA6),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.displayField!(item),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: responsive.diagonalP(1.52),
                fontWeight: FontWeight.w700,
                color: const Color(0xFF243447),
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customItemPopup(BuildContext context, T? item, bool isSelected) {
    final responsive = ResponsiveUtil();

    if (item == null || widget.displayField == null) {
      return const SizedBox.shrink();
    }

    final text = widget.displayField!(item);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF195BA6).withOpacity(0.10)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF195BA6)
              : const Color(0xFFE1E8F0),
          width: isSelected ? 1.4 : 1.0,
        ),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (isSelected
                ? const Color(0xFF195BA6)
                : Colors.blueGrey.shade400)
                .withOpacity(0.10),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            isSelected ? Icons.check_circle_rounded : (widget.icon ?? Icons.list_alt_rounded),
            color: isSelected
                ? const Color(0xFF195BA6)
                : Colors.blueGrey.shade500,
            size: 20,
          ),
        ),
        title: Text(
          text,
          style: TextStyle(
            fontSize: responsive.diagonalP(1.45),
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? const Color(0xFF0A2E5C)
                : const Color(0xFF243447),
            height: 1.2,
          ),
        ),
      ),
    );
  }
}