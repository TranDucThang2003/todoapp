import 'package:chart_example/blocs/task_bloc/task_event.dart';
import 'package:chart_example/blocs/task_bloc/task_state.dart';
import 'package:chart_example/models/task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final List<Task> _task = [
    Task(
      id: 1,
      title: "title",
      description: "description",
      createAt: DateTime.now(),
    ),
    Task(
      id: 2,
      title: "title",
      description: "description",
      createAt: DateTime.now(),
    ),
    Task(
      id: 3,
      title: "title",
      description: "description",
      createAt: DateTime.now(),
    ),
  ];

  TaskBloc() : super(TaskInitial()) {
    on<LoadTask>(_onLoadTask);
    on<ToggleTask>(_onToggleTask);
    on<AddTask>(_onAddTask);
  }

  void _onLoadTask(LoadTask event, Emitter<TaskState> emit) {
    emit(TaskLoaded(tasks: _task));
  }

  void _onToggleTask(ToggleTask event, Emitter<TaskState> emit) {
    if (state is TaskLoaded) {
      final tasks = (state as TaskLoaded).tasks.map((task) {
        if (task.id == event.taskId) {
          return task.copyWith(isDone: !task.isDone);
        }
        return task;
      }).toList();
      emit(TaskLoaded(tasks: tasks));

      ////
    }
  }

  void _onAddTask(AddTask event, Emitter<TaskState> emit) {
    Task t = Task(
      id: _task.length + 1,
      title: event.title,
      description: event.description,
      createAt: event.createAt,
    );
    _task.add(t);
    emit(TaskLoaded(tasks: _task));
  }
  void _onEditTask(EditTask event, Emitter<TaskState> emit){
    try{
      if(state is TaskLoaded){
        final task = (state as TaskLoaded).tasks.firstWhere((t)=> t.id == event.id);
        _task.remove(task);
        _task.add()
      }
    }catch(e){
      emit(TaskError());
    }
  }
}
