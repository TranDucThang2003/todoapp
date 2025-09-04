import 'package:chart_example/blocs/data/repositories/task_repository.dart';
import 'package:chart_example/blocs/task_bloc/task_event.dart';
import 'package:chart_example/blocs/task_bloc/task_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/data_sources/app_database.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _repository;

  Stream<List<Task>>? _taskStream;

  TaskBloc(this._repository) : super(TaskInitial()) {
    on<LoadTask>(_onLoadTask);
    on<ToggleTask>(_onToggleTask);
    on<AddTask>(_onAddTask);
    on<EditTask>(_onEditTask);
    on<DeleteTask>(_onDeleteTask);
  }

  void _onLoadTask(LoadTask event, Emitter<TaskState> emit) {
    _taskStream = _repository.watchAllTask();
    _taskStream!.listen((tasks) {
      emit(TaskLoaded(tasks));
    });
  }

  Future<void> _onToggleTask(ToggleTask event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentTasks = (state as TaskLoaded).tasks;
      final updatedTasks = currentTasks.map((task) {
        if (task.id == event.taskId) {
          return task.copyWith(isDone: !task.isDone);
        }
        return task;
      }).toList();

      // Cập nhật UI trước
      emit(TaskLoaded(updatedTasks));

      try {
        final taskToUpdate = currentTasks.firstWhere((task) => task.id == event.taskId);
        await _repository.updateIsDone(taskToUpdate.id, !taskToUpdate.isDone);
      } catch (e) {
        emit(TaskError());
      }
    }
  }


  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    await _repository.insertTask(
      TasksCompanion.insert(
        title: event.title,
        description: event.description ?? "",
      ),
    );
  }

  Future<void> _onEditTask(EditTask event, Emitter<TaskState> emit) async {
    if(state is TaskLoaded){
      final current = (state as TaskLoaded).tasks;
      final taskToUpdate = current.firstWhere((t)=>t.id==event.id);

      final updatedTask = taskToUpdate.copyWith(
        title: event.title ?? taskToUpdate.title,
        description: event.description ?? taskToUpdate.description,
        createdAt: event.createAt ?? taskToUpdate.createdAt,
      );

      // Cập nhật vào DB
      await _repository.updateTask(updatedTask);

      // Cập nhật UI
      final updatedList = current.map((t) => t.id == event.id ? updatedTask : t).toList();
      emit(TaskLoaded(updatedList));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    await _repository.deleteTask(event.id);
  }
}
