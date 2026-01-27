part of 'custom_widgets.dart';
class ModuleCard extends StatefulWidget {
  final String title;
  final String? base64Img;
  final VoidCallback onTap;

  const ModuleCard({
    Key? key,
    required this.title,
    this.base64Img,
    required this.onTap,
  }) : super(key: key);

  @override
  State<ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<ModuleCard> {
  bool _pressed = false;

  void _onTapDown(TapDownDetails _) => setState(() => _pressed = true);
  void _onTapUp(TapUpDetails _) => setState(() => _pressed = false);
  void _onTapCancel() => setState(() => _pressed = false);

  @override
  Widget build(BuildContext context) {
    final scale = _pressed ? 0.96 : 1.0;
    final blur = _pressed ? 4.0 : 14.0;
    final shadowColor = Colors.black.withOpacity(0.15);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.identity()..scale(scale),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.85),
              Colors.grey.shade100.withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: blur,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
              child: SingleChildScrollView(child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🔷 Imagen o ícono con fondo circular institucional
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF195ba6), Color(0xFF6c757d)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF195ba6).withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: widget.base64Img == null
                          ? const Icon(
                        Icons.apps_rounded,
                        size: 30,
                        color: Colors.white,
                      )
                          : Image.memory(
                        base64Decode(widget.base64Img!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // 🔸 Texto del módulo
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      widget.title.toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF06245B),
                        letterSpacing: 0.4,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 🔹 Línea decorativa institucional
                  Container(
                    width: 35,
                    height: 3.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF195ba6),
                          Color(0xFF6c757d),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                ],
              ),),
            ),
          ),
        ),
      ),
    );
  }
}
