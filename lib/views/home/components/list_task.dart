import 'package:chart_example/blocs/task_bloc/task_bloc.dart';
import 'package:chart_example/blocs/task_bloc/task_event.dart';
import 'package:chart_example/blocs/task_bloc/task_state.dart';
import 'package:chart_example/items/task_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListTask extends StatefulWidget {
  const ListTask({super.key});

  @override
  State<StatefulWidget> createState() => _ListTask();
}

class _ListTask extends State<ListTask> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoaded) {
            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                return TaskItem(
                  onChangedValue: (_) => context.read<TaskBloc>().add(
                    ToggleTask(taskId: state.tasks[index].id),
                  ),
                  task: state.tasks[index],
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
