import 'package:chart_example/blocs/data/data_sources/app_database.dart';

class NoteRepository{
  final AppDatabase _db;
  NoteRepository(this._db);

  Stream<List<Note>> watchAllNote(){
    return _db.select(_db.notes).watch();
  }

  Future<int> insertNote(NotesCompanion note){
    return _db.into(_db.notes).insert(note);
  }

  Future<void> updateNote(Note note){
    return _db.update(_db.notes).replace(note);
  }

  Future<void> deleteNote(int id){
    return (_db.delete(_db.notes)..where((tbl) => tbl.id.equals(id))).go();
  }
}