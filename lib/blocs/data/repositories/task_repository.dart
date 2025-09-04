import 'package:chart_example/blocs/data/data_sources/app_database.dart';
import 'package:drift/drift.dart';

class TaskRepository{
  final AppDatabase _db;
  TaskRepository(this._db);

  Stream<List<Task>> watchAllTask(){
    return _db.select(_db.tasks).watch();
  }

  Future<int> insertTask(TasksCompanion task){
    return _db.into(_db.tasks).insert(task);
  }

  Future<void> updateTask(Task task){
    return _db.update(_db.tasks).replace(task);
  }
  Future<void> updateIsDone(int id, bool isDone){
    return (_db.update(_db.tasks)..where((t)=>t.id.equals(id))).write(TasksCompanion(isDone: Value(isDone)));
  }

  Future<void> deleteTask(int id){
    return (_db.delete(_db.tasks)..where((tbl)=> tbl.id.equals(id))).go();
  }
}