import 'package:chart_example/views/task_action/task_form_screen.dart';
import 'package:flutter/material.dart';

import '../models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onChangedValue;

  const TaskItem({
    super.key,
    required this.onChangedValue, required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(pageBuilder: (context, _, __) => TaskFormScreen(task: task,)),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4), // màu shadow
                blurRadius: 5, // độ mờ
                spreadRadius: 1, // độ lan
                offset: Offset(0, 4), // hướng đổ bóng
              ),
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(value: task.isDone, onChanged: onChangedValue),
              SizedBox(width: 10),
              Text(task.title),
            ],
          ),
        ),
      ),
    );
  }
}
