import 'package:chart_example/blocs/task_bloc/task_bloc.dart';
import 'package:chart_example/blocs/task_bloc/task_event.dart';
import 'package:chart_example/blocs/task_bloc/task_state.dart';
import 'package:chart_example/items/task_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chart_example/utils/helpers.dart';

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
            final groupedTasks = groupTasksByDate(state.tasks);
            final sortedDates = groupedTasks.keys.toList()
              ..sort((a, b) => b.compareTo(a));

            return ListView(
              children: sortedDates.map((date) {
                final tasks = groupedTasks[date]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "${date.day}/${date.month}/${date.year}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...tasks.map(
                      (task) => TaskItem(
                        onChangedValue: (_) => context.read<TaskBloc>().add(
                          ToggleTask(taskId: task.id),
                        ),
                        task: task,
                      ),
                    ),
                  ],
                );
              }).toList(),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
