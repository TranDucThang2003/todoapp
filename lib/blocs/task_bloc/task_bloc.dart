import 'package:chart_example/blocs/data/repositories/task_repository.dart';
import 'package:chart_example/blocs/task_bloc/task_event.dart';
import 'package:chart_example/blocs/task_bloc/task_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/data_sources/app_database.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _taskRepository;

  TaskBloc(this._taskRepository) : super(TaskInitial()) {
    on<LoadTask>(_onLoadTask);
    on<ToggleTask>(_onToggleTask);
    on<AddTask>(_onAddTask);
    on<EditTask>(_onEditTask);
    on<DeleteTask>(_onDeleteTask);
  }

  Future<void> _onLoadTask(LoadTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());

    await emit.forEach(
        _taskRepository.watchAllTask(),
        onData: (tasks)=>TaskLoaded(tasks),
        onError: (_,__)=>TaskError()
    );
  }

  Future<void> _onToggleTask(ToggleTask event, Emitter<TaskState> emit) async {
    if(state is !TaskLoaded) return ;

    try{
      final currentTasks = (state as TaskLoaded).tasks;
      final task = currentTasks.firstWhere((task)=> task.id == event.taskId);

      await _taskRepository.updateIsDone(task.id, !task.isDone);
    }catch(e){
      emit(TaskError());
    }
  }


  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    try{
      await _taskRepository.insertTask(
        TasksCompanion.insert(
          title: event.title,
          description: event.description ?? "",
        ),
      );
    }catch(e){
      emit(TaskError());
    }
  }

  Future<void> _onEditTask(EditTask event, Emitter<TaskState> emit) async {
    if(state is! TaskLoaded) return;

    final currentTasks = (state as TaskLoaded).tasks;
    final taskToUpdate = currentTasks.firstWhere((task)=> task.id == event.id);

    final updatedTask = taskToUpdate.copyWith(
      title: event.title ?? taskToUpdate.title,
      description: event.description ?? taskToUpdate.description,
      createdAt: event.createAt ?? taskToUpdate.createdAt,
    );

    await _taskRepository.updateTask(updatedTask);
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try{
      await _taskRepository.deleteTask(event.id);
    }catch(e){
      emit(TaskError());
    }
  }
}
