import 'package:chart_example/blocs/task_bloc/task_bloc.dart';
import 'package:chart_example/blocs/task_bloc/task_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../blocs/data/data_sources/app_database.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  const TaskFormScreen({super.key, this.task});

  @override
  State<StatefulWidget> createState() => _TaskFormScreen();
}

class _TaskFormScreen extends State<TaskFormScreen> {
  late TextEditingController _titleController;

  late TextEditingController _descriptionController;

  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.task != null ? widget.task!.title : "",
    );
    _descriptionController = TextEditingController(
      text: widget.task != null ? widget.task!.description : "",
    );
    _selectedDate = widget.task != null
        ? widget.task!.createdAt
        : DateTime.now();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdd = widget.task == null;
    return Scaffold(
      appBar: AppBar(
        title: isAdd
            ? Text(
                "ADD TASK",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              )
            : Text(
                "EDIT TASK",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "Task title",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "Task description...",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                GestureDetector(
                  onTap: _pickDate,
                  child: Text(
                    "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                if (_titleController.text == "") {
                  Fluttertoast.showToast(msg: "Title can't blank");
                  return;
                }
                isAdd
                    ? context.read<TaskBloc>().add(
                        AddTask(
                          title: _titleController.text,
                          description: _descriptionController.text,
                          createAt: _selectedDate
                        ),
                      )
                    : context.read<TaskBloc>().add(
                        EditTask(
                          id: widget.task!.id,
                          title: _titleController.text != widget.task!.title
                              ? _titleController.text
                              : null,
                          description: _descriptionController.text != widget.task!.title
                              ? _descriptionController.text
                              : null,
                          createAt: _selectedDate != widget.task!.createdAt
                              ? _selectedDate
                              : null,
                        ),
                      );
                Navigator.pop(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: isAdd
                      ? const Text(
                          "Add",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : const Text(
                          "Edit",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
