import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../blocs/data/data_sources/app_database.dart';
import '../../blocs/note_bloc/note_bloc.dart';
import '../../blocs/note_bloc/note_event.dart';

class NoteFormScreen extends StatefulWidget {
  final Note? note;

  const NoteFormScreen({super.key, this.note});

  @override
  State<StatefulWidget> createState() => _NoteFormScreen();
}

class _NoteFormScreen extends State<NoteFormScreen> {
  late TextEditingController _titleController;

  late TextEditingController _contentController;

  late DateTime _selectedDate;

  File? _image;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.note != null ? widget.note!.title : "",
    );
    _contentController = TextEditingController(
      text: widget.note != null ? widget.note!.content : "",
    );
    _selectedDate = widget.note != null
        ? widget.note!.createdAt
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

  Future<void> _pickAndSaveImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    // copy ảnh vào bộ nhớ của app
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String newPath = '${appDir.path}/${DateTime.now().millisecondsSinceEpoch}.png';

    final File newImage = await File(pickedFile.path).copy(newPath);

    setState(() {
      _image = newImage;
      _imagePath = newPath;
    });

    // // Lấy đường dẫn này để lưu vào DB
    // print("Đường dẫn lưu trong DB: $newPath");
  }

  @override
  Widget build(BuildContext context) {
    final isAdd = widget.note == null;
    return Scaffold(
      appBar: AppBar(
        title: isAdd
            ? Text(
                "ADD NOTE",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              )
            : Text(
                "EDIT NOTE",
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
                hintText: "Note title",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "Note content...",
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image != null
                  ? Image.file(
                      _image!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : Text("Chưa chọn ảnh"),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickAndSaveImage,
                child: Text("Chọn ảnh từ thư viện"),
              ),
            ],
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
                    ? context.read<NoteBloc>().add(
                        AddNote(
                          title: _titleController.text,
                          content: _contentController.text,
                          createAt: _selectedDate,
                          imagePath: _imagePath
                        ),
                      )
                    : context.read<NoteBloc>().add(
                        EditNote(
                          id: widget.note!.id,
                          title: _titleController.text != widget.note!.title
                              ? _titleController.text
                              : null,
                          content: _contentController.text != widget.note!.title
                              ? _contentController.text
                              : null,
                          createAt: _selectedDate != widget.note!.createdAt
                              ? _selectedDate
                              : null,
                          imagePath: _imagePath
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
