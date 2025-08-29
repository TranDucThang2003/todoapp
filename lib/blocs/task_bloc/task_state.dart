import '../../models/task.dart';

abstract class TaskState{}

class TaskInitial extends TaskState{}

class TaskLoading extends TaskState{}

class TaskError extends TaskState{}

class TaskLoaded extends TaskState{
  final List<Task> tasks;

  TaskLoaded({required this.tasks});
}

