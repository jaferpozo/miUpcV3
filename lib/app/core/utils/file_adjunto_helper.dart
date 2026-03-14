import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import '../../data/models/models.dart';
class FileAdjuntoHelper {
  static Future<AdjuntoModel?> seleccionarArchivo() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'pdf',
        'doc',
        'docx',
        'xls',
        'xlsx',
        'txt',
      ],
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final picked = result.files.first;

    if (picked.path == null) {
      return null;
    }

    final file = File(picked.path!);
    final mimeType = lookupMimeType(picked.path!) ?? 'application/octet-stream';
    final extension = picked.extension ?? '';

    return AdjuntoModel(
      file: file,
      nombre: picked.name,
      mimeType: mimeType,
      tamanioBytes: picked.size,
      extension: extension,
    );
  }
}
