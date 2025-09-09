import 'dart:async';

import 'package:chart_example/blocs/data/repositories/note_repository.dart';
import 'package:chart_example/blocs/note_bloc/note_event.dart';
import 'package:chart_example/blocs/note_bloc/note_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/data_sources/app_database.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository _noteRepository;

  NoteBloc(this._noteRepository) : super(NoteInitial()) {
    on<LoadNote>(_onLoadNote);
    on<AddNote>(_onAddNote);
    on<EditNote>(_onEditNote);
    on<DeleteNote>(_onDeleteNote);
  }

  Future<void> _onLoadNote(LoadNote event, Emitter<NoteState> emit) async {
    await emit.forEach(
        _noteRepository.watchAllNote(),
        onData: (notes) => NoteLoaded(notes: notes),
        onError: (_,__)=>NoteError());
  }

  Future<void> _onAddNote(AddNote event, Emitter<NoteState> emit) async {
    if(state is! NoteLoaded) return;

    try{
      await _noteRepository.insertNote(
        NotesCompanion.insert(
          title: event.title,
          content: event.content,
          imagePath: event.imagePath,
          createdAt: event.createAt,);
      );
    }catch(e){
      emit(NoteError());
    }
  }

  void _onEditNote(EditNote event, Emitter<NoteState> emit) {
    if (state is NoteLoaded) {
      final current = (state as NoteLoaded).notes;

      final updated = current.map((note) {
        if (note.id == event.id) {
          return Note(
            id: event.id,
            title: event.title ?? note.title,
            createdAt: event.createAt ?? DateTime.now(),
            imagePath: event.imagePath,
            content: event.content ?? note.content,
          );
        }
        return note;
      }).toList();
      emit(NoteLoaded(notes: updated));
    }
  }

  void _onDeleteNote(DeleteNote event, Emitter<NoteState> emit) {
    if (state is NoteLoaded) {
      final notes = (state as NoteLoaded).notes;

      final updated = notes.where((note) => note.id != event.id).toList();

      emit(NoteLoaded(notes: updated));
    }
  }
}
