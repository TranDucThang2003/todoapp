import 'package:flutter/material.dart';

class NoteItem extends StatefulWidget{
  const NoteItem({super.key});

  @override
  State<StatefulWidget> createState() => _NoteItem();

}

class _NoteItem extends State<NoteItem>{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text("NoteTitle"),
          Text("Description")
        ],
      ),
    );
  }
}