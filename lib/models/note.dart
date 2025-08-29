class Note {
  final int id;
  final String title;
  final String content;
  final String? imagePath;
  final DateTime createAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.imagePath,
    required this.createAt,
  });
}
