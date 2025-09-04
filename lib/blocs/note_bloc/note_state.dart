import '../data/data_sources/app_database.dart';

abstract class NoteState {}

class NoteInitial extends NoteState{}

class NoteLoading extends NoteState{}

class NoteError extends NoteState{}

class NoteLoaded extends NoteState{
  final List<Note> notes;

  NoteLoaded({required this.notes});
}
