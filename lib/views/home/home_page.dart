import 'package:chart_example/views/home/components/list_notes.dart';
import 'package:chart_example/views/home/components/list_task.dart';
import 'package:chart_example/views/task_action/task_form_screen.dart';
import 'package:flutter/material.dart';
import '../task_action/note_form_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Todo + Notes',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Center(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _currentIndex = 0;
                            });
                          },
                          child: Text(
                            'TASKS',
                            style: TextStyle(
                              fontSize: 20,
                              color: _currentIndex == 0
                                  ? Colors.blueAccent
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: _currentIndex == 0
                            ? Colors.blueAccent
                            : Colors.transparent,
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 5,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Center(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _currentIndex = 1;
                            });
                          },
                          child: Text(
                            'NOTES',
                            style: TextStyle(
                              fontSize: 20,
                              color: _currentIndex == 1
                                  ? Colors.blueAccent
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: _currentIndex == 1
                            ? Colors.blueAccent
                            : Colors.transparent,
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(child: _currentIndex == 0 ? ListTask() : ListNotes()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentIndex == 0) {
            Navigator.push(
              context,
              PageRouteBuilder(pageBuilder: (context,_,__) => TaskFormScreen()),
            );
          } else {
            Navigator.push(
              context,
              PageRouteBuilder(pageBuilder: (context,_,__) => NoteFormScreen()),
            );
          }
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(label: 'TASK', icon: Icon(Icons.check_box)),
          BottomNavigationBarItem(label: 'NOTES', icon: Icon(Icons.notes)),
        ],
        onTap: (indexItem) {
          setState(() {
            _currentIndex = indexItem;
            print(_currentIndex);
          });
        },
      ),
    );
  }
}
