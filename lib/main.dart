import 'package:chart_example/blocs/data/repositories/task_repository.dart';
import 'package:chart_example/blocs/note_bloc/note_bloc.dart';
import 'package:chart_example/blocs/note_bloc/note_event.dart';
import 'package:chart_example/blocs/task_bloc/task_bloc.dart';
import 'package:chart_example/blocs/task_bloc/task_event.dart';
import 'package:chart_example/views/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/data/data_sources/app_database.dart';
import 'blocs/data/repositories/note_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase(); // Khởi tạo DB
  final taskRepository = TaskRepository(database);
  final noteRepository = NoteRepository(database);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TaskBloc(taskRepository)..add(LoadTask())),
        BlocProvider(create: (_) => NoteBloc(noteRepository)..add(LoadNote())),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(),
    );
  }
}
