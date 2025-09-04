import 'package:chart_example/blocs/note_bloc/note_state.dart';
import 'package:chart_example/items/note_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/note_bloc/note_bloc.dart';

class ListNotes extends StatefulWidget {
  const ListNotes({super.key});

  @override
  State<StatefulWidget> createState() => _ListNotes();
}

class _ListNotes extends State<ListNotes> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is NoteLoaded) {
            return ListView.builder(
              itemCount: state.notes.length,
              itemBuilder: (context, index) {
                return NoteItem(note: state.notes[index]);
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
