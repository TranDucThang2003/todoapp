import 'package:chart_example/blocs/task_bloc/task_bloc.dart';
import 'package:chart_example/blocs/task_bloc/task_event.dart';
import 'package:chart_example/views/task_action/task_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/data/data_sources/app_database.dart';


class TaskItem extends StatefulWidget{
  final Task task;
  final ValueChanged<bool?> onChangedValue;

  const TaskItem({super.key, required this.onChangedValue, required this.task});

  @override
  State<StatefulWidget> createState() => _TaskItem();
}

class _TaskItem extends State<TaskItem> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            onLongPress: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SafeArea(
                    child: Wrap(
                      children: [
                        ListTile(
                            leading: Icon(Icons.edit),
                            iconColor: Colors.blueAccent,
                            title: Text("Edit"),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(context, PageRouteBuilder(pageBuilder: (context,_,__)=>TaskFormScreen(task : widget.task)));
                            }
                        ),
                        ListTile(
                            leading: Icon(Icons.delete),
                            iconColor: Colors.red,
                            title: Text("Delete"),
                            onTap: () {
                              context.read<TaskBloc>().add(DeleteTask(id: widget.task.id));
                              Navigator.pop(context);
                            }
                        ),
                      ],
                    ),
                  );
                },
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
                  Checkbox(value: widget.task.isDone, onChanged: widget.onChangedValue,),
                  SizedBox(width: 10),
                  Text(widget.task.title),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: _expanded
                ? Container(
              width: double.infinity, // full ngang theo item
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                widget.task.description,
                style: const TextStyle(fontSize: 16),
              ),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
