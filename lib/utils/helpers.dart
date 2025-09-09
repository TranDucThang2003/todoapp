import '../blocs/data/data_sources/app_database.dart';

Map<DateTime, List<Task>> groupTasksByDate(List<Task> tasks) {
  final Map<DateTime, List<Task>> grouped = {};
  for (var task in tasks) {
    final date = DateTime(task.createdAt.year, task.createdAt.month, task.createdAt.day);
    grouped.putIfAbsent(date, () => []);
    grouped[date]!.add(task);
  }
  return grouped;
}

Map<DateTime, List<Note>> groupNotesByDate(List<Note> notes) {
  final Map<DateTime, List<Note>> grouped = {};
  for (var note in notes) {
    final date = DateTime(note.createdAt.year, note.createdAt.month, note.createdAt.day);
    grouped.putIfAbsent(date, () => []);
    grouped[date]!.add(note);
  }
  return grouped;
}