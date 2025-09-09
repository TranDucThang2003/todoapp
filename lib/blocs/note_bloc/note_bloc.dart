import 'dart:async';

import 'package:chart_example/blocs/data/repositories/note_repository.dart';
import 'package:chart_example/blocs/note_bloc/note_event.dart';
import 'package:chart_example/blocs/note_bloc/note_state.dart';
import 'package:drift/drift.dart';
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
      onError: (_, __) => NoteError(),
    );
  }

  Future<void> _onAddNote(AddNote event, Emitter<NoteState> emit) async {
    if (state is! NoteLoaded) return;

    try {
      await _noteRepository.insertNote(
        NotesCompanion.insert(
          title: event.title,
          content: Value(event.content),
          imagePath: Value(event.imagePath),
          createdAt: Value(event.createAt),
        ),
      );
    } catch (e) {
      emit(NoteError());
    }
  }

  Future<void> _onEditNote(EditNote event, Emitter<NoteState> emit) async {
    if (state is! NoteLoaded) return;

    try {
      final currentNotes = (state as NoteLoaded).notes;
      final noteToUpdate = currentNotes.firstWhere((n) => n.id == event.id);
      final updatedNote = noteToUpdate.copyWith(
        title: event.title ?? noteToUpdate.title,
        content: event.content != null
            ? Value(event.content)
            : const Value.absent(),
        imagePath: event.imagePath != null
            ? Value(event.imagePath)
            : const Value.absent(),
        createdAt: event.createAt ?? noteToUpdate.createdAt,
      );
      await _noteRepository.updateNote(updatedNote);
    } catch (e) {
      emit(NoteError());
    }
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<NoteState> emit) async {
    if (state is! NoteLoaded) return;
    try {
      await _noteRepository.deleteNote(event.id);
    } catch (e) {
      emit(NoteError());
    }
  }
}
