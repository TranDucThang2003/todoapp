class Task {
  final int id;
  final String title;
  final String description;
  final bool isDone;
  final DateTime createAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isDone = false,
    required this.createAt,
  });

  Task copyWith({bool? isDone}){
    return Task(id: id, title: title, description: description, isDone: isDone ?? false, createAt: createAt);
  }
}
