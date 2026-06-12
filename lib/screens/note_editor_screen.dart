import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/note.dart';
import '../helpers/file_helper.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;
  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late Note _currentNote;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  Map<int, File> _loadedImages = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _currentNote = widget.note!;
      _titleController.text = _currentNote.title;
      _contentController.text = _currentNote.content;
    } else {
      _currentNote = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: '',
        content: '',
        imageCount: 0,
      );
    }
    _loadImagesFromStorage();
  }

  Future<void> _loadImagesFromStorage() async {
    Map<int, File> tempImages = {};
    for (int i = 1; i <= 3; i++) {
      final file = await FileHelper.getNoteImageFile(_currentNote.id, i);
      if (file != null) {
        tempImages[i] = file;
      }
    }
    setState(() {
      _loadedImages = tempImages;
      _currentNote.imageCount = _loadedImages.length;
    });
  }

  Future<void> _pickAndSaveImage() async {
    if (_currentNote.imageCount >= 3) return;

    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() => _isLoading = true);
      
      int targetIndex = 1;
      for (int i = 1; i <= 3; i++) {
        if (!_loadedImages.containsKey(i)) {
          targetIndex = i;
          break;
        }
      }

      await FileHelper.saveNoteImage(_currentNote.id, targetIndex, pickedFile.path);
      await _loadImagesFromStorage();
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteImage(int index) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    await FileHelper.deleteNoteImage(_currentNote.id, index);
    await _loadImagesFromStorage();
    
    messenger.showSnackBar(
      SnackBar(
        content: Text('Gambar $index berhasil dihapus'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.note == null ? 'Catatan Baru' : 'Ubah Catatan',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: FilledButton.icon(
              onPressed: () {
                if (!mounted) return;
                _currentNote.title = _titleController.text.trim();
                _currentNote.content = _contentController.text.trim();
                Navigator.of(context).pop(_currentNote); // Mengembalikan objek catatan ke halaman daftar
              },
              icon: const Icon(Icons.done_all_rounded, size: 18),
              label: const Text('Simpan'),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: 'Masukkan judul fantastis...',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 24),
                  border: InputBorder.none,
                ),
              ),
              const Divider(height: 20, thickness: 1, color: Color(0xFFE9ECEF)),
              
              Expanded(
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  expands: true,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                  decoration: InputDecoration(
                    hintText: 'Mulai mengetik ide cemerlang Anda di sini...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: InputBorder.none,
                  ),
                ),
              ),
              
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.collections_rounded, color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Lampiran Foto',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800], fontSize: 15),
                      ),
                    ],
                  ),
                  Text(
                    '${_currentNote.imageCount} / 3',
                    style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              SizedBox(
                height: 110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ..._loadedImages.entries.map((entry) {
                      int index = entry.key;
                      File file = entry.value;
                      return Container(
                        margin: const EdgeInsets.only(right: 14.0, top: 4, bottom: 4),
                        width: 100,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(file, fit: BoxFit.cover, width: 100, height: 100),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => _deleteImage(index),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close_rounded, color: Colors.white, size: 14),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 4,
                              left: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Foto $index',
                                  style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    if (_currentNote.imageCount < 3)
                      GestureDetector(
                        onTap: _isLoading ? null : _pickAndSaveImage,
                        child: Container(
                          margin: const EdgeInsets.only(right: 14.0, top: 4, bottom: 4),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: theme.colorScheme.primary.withValues(alpha: 0.25),
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: _isLoading
                              ? const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)))
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_photo_alternate_rounded, size: 28, color: theme.colorScheme.primary),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Tambah',
                                      style: TextStyle(fontSize: 11, color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}