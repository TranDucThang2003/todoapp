import 'package:equatable/equatable.dart';

import '../data/data_sources/app_database.dart';

abstract class TaskEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class LoadTask extends TaskEvent {}

class ToggleTask extends TaskEvent {
  final int taskId;
  ToggleTask({required this.taskId});
}

class AddTask extends TaskEvent {
  final String title;
  final String? description;
  AddTask({required this.title, this.description});
}

class EditTask extends TaskEvent {
  final int id;
  final String? title;
  final String? description;
  final DateTime? createAt;

  EditTask({required this.id, this.title,this.description , this.createAt});
}

class DeleteTask extends TaskEvent {
  final int id;

  DeleteTask({required this.id});
}
