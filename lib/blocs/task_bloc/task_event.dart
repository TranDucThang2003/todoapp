import '../../models/task.dart';

abstract class TaskEvent {}

class LoadTask extends TaskEvent {}

class ToggleTask extends TaskEvent {
  final int taskId;

  ToggleTask({required this.taskId});
}

class AddTask extends TaskEvent {
  final String title;
  final String description;
  final DateTime createAt;

  AddTask({
    required this.createAt,
    required this.title,
    required this.description,
  });
}

class EditTask extends TaskEvent {
  final int id;
  final String? title;
  final String? description;
  final DateTime? createAt;

  EditTask({
    required this.id,
    required this.title,
    required this.description,
    required this.createAt,
  });
}

class DeleteTask extends TaskEvent {}
