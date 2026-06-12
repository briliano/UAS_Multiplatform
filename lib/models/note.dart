class Note {
  final String id;
  String title;
  String content;
  int imageCount; // Menyimpan jumlah lampiran gambar (maksimal 3)

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.imageCount = 0,
  });
}