import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class FileHelper {
  static Future<String> _getNoteDirPath(String noteId) async {
    final docsDir = await getApplicationDocumentsDirectory();
    return join(docsDir.path, 'notes', noteId);
  }

  // Menyimpan berkas gambar berdasarkan indeks (1, 2, atau 3)
  static Future<void> saveNoteImage(String noteId, int index, String sourcePath) async {
    final noteDirPath = await _getNoteDirPath(noteId);
    final noteDir = Directory(noteDirPath);

    if (!await noteDir.exists()) {
      await noteDir.create(recursive: true);
    }

    final targetPath = join(noteDirPath, 'image_$index.jpg');
    final sourceFile = File(sourcePath);
    
    if (await sourceFile.exists()) {
      await sourceFile.copy(targetPath);
    }
  }

  // Menghapus satu gambar tanpa memengaruhi gambar lainnya
  static Future<void> deleteNoteImage(String noteId, int index) async {
    final noteDirPath = await _getNoteDirPath(noteId);
    final imageFile = File(join(noteDirPath, 'image_$index.jpg'));

    if (await imageFile.exists()) {
      await imageFile.delete();
    }
  }

  // Mengambil file gambar jika ada
  static Future<File?> getNoteImageFile(String noteId, int index) async {
    final noteDirPath = await _getNoteDirPath(noteId);
    final imageFile = File(join(noteDirPath, 'image_$index.jpg'));

    if (await imageFile.exists()) {
      return imageFile;
    }
    return null;
  }
}