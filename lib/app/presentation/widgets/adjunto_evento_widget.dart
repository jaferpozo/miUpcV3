part of 'custom_widgets.dart';
class AdjuntoEventoWidget extends StatelessWidget {
  final AdjuntoModel? archivo;
  final bool cargando;
  final VoidCallback onSeleccionar;
  final VoidCallback onEliminar;

  const AdjuntoEventoWidget({
    super.key,
    required this.archivo,
    required this.cargando,
    required this.onSeleccionar,
    required this.onEliminar,
  });

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  IconData _getIconByMime(String mime) {
    if (mime.startsWith('image/')) return Icons.image_outlined;
    if (mime.contains('pdf')) return Icons.picture_as_pdf_outlined;
    if (mime.contains('word') || mime.contains('document')) {
      return Icons.description_outlined;
    }
    if (mime.contains('excel') || mime.contains('sheet')) {
      return Icons.table_chart_outlined;
    }
    return Icons.attach_file_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final bool tieneArchivo = archivo != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: cargando ? null : onSeleccionar,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FBFD),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: tieneArchivo
                    ? const Color(0xFFBFD4EC)
                    : const Color(0xFFD7E3F1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF195BA6).withOpacity(0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    tieneArchivo
                        ? _getIconByMime(archivo!.mimeType)
                        : Icons.upload_file_outlined,
                    color: const Color(0xFF195BA6),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: cargando
                      ? const Text(
                    "Cargando archivo...",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0A2E5C),
                    ),
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tieneArchivo
                            ? archivo!.nombre
                            : "Adjuntar imagen o archivo",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0A2E5C),
                          fontSize: 14.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tieneArchivo
                            ? "${archivo!.mimeType} • ${_formatBytes(archivo!.tamanioBytes)}"
                            : "Formatos permitidos: JPG, PNG, PDF, DOC, DOCX, XLS, XLSX, TXT",
                        style: TextStyle(
                          color: Colors.blueGrey.shade600,
                          fontSize: 12.8,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                if (cargando)
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.3),
                  )
                else
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF195BA6),
                  ),
              ],
            ),
          ),
        ),

        if (tieneArchivo) ...[
          const SizedBox(height: 12),
          if (archivo!.superaCincoMb)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7E8),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF1D7A6)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.wifi_outlined,
                    color: Color(0xFFC28A10),
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "El archivo supera los 5 MB. Se recomienda conectarse a una red Wi-Fi antes de enviarlo.",
                      style: TextStyle(
                        color: Color(0xFF8A5A00),
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onEliminar,
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.redAccent,
              ),
              label: const Text(
                "Quitar archivo",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
