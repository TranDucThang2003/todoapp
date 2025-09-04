abstract class NoteEvent{}

class LoadNote extends NoteEvent{}

class AddNote extends NoteEvent{
  final String title;
  final String content;
  final String? imagePath;
  final DateTime createAt;

  AddNote({required this.title, required this.content, this.imagePath , required this.createAt});
}

class EditNote extends NoteEvent{
  final int id;
  final String? title;
  final String? content;
  final String? imagePath;
  final DateTime? createAt;

  EditNote({required this.id, this.title, this.content, this.imagePath, this.createAt});
}

class DeleteNote extends NoteEvent{
  final int id;

  DeleteNote({required this.id});
}