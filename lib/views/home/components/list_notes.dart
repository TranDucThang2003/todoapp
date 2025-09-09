import 'package:chart_example/blocs/note_bloc/note_state.dart';
import 'package:chart_example/items/note_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/note_bloc/note_bloc.dart';
import '../../../utils/helpers.dart';

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
            if(state.notes.isEmpty) return Center(child: Text("không có lời nhắc nào!"),);

            final groupedNotes = groupNotesByDate(state.notes);
            final sortedDates = groupedNotes.keys.toList()
              ..sort((a, b) => b.compareTo(a));
            return ListView(
              children: sortedDates.map((date) {
                final tasks = groupedNotes[date]!;

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
                    ...tasks.map((note) => NoteItem(note: note)),
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
