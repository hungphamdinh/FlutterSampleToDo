import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter App Learning',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String title = '';
  String content = '';
  final List<Task> data = <Task>[];

  void _handleTodoChange(Task newTask) {
    setState(() {
      data.map((Task task) {
        if (task.id == newTask.id) {
          task.isCompleted = !newTask.isCompleted;
        }
      }).toList();
    });
  }

  void showInputModal(context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.amber,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('ADD TASK'),
                TextField(
                  onChanged: (text) {
                    setState(() {
                      title = text;
                    });
                  },
                ),
                TextField(
                  onChanged: (text) {
                    setState(() {
                      content = text;
                    });
                  },
                ),
                Padding(padding: const EdgeInsets.only(top: 10)),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(
                    child: const Text('Add'),
                    onPressed: () => {
                      setState(() {
                        data.add(Task(title, content, false, data.length + 1));
                      }),
                      Navigator.pop(context)
                    },
                  ),
                  Padding(padding: const EdgeInsets.all(8.8)),
                  ElevatedButton(
                    child: const Text('Close'),
                    onPressed: () => Navigator.pop(context),
                  )
                ])
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("To Do List"),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  Task taskItem = Task(data[index].title, data[index].content,
                      data[index].isCompleted, data[index].id);
                  return UserWidget(
                    taskData: taskItem,
                    onTodoChanged: _handleTodoChange,
                  );
                },
                itemCount: data.length,
                shrinkWrap: true,
              )
            ],
          ),
        ),
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.add),
            backgroundColor: Colors.green,
            onPressed: () {
              // showInputModal(context);
              showInputModal(context);
            }));
  }
}

class Task {
  final String title;
  final String content;
  bool isCompleted;
  final int id;

  Task(this.title, this.content, this.isCompleted, this.id);
}

class UserWidget extends StatelessWidget {
  final Task taskData;
  final onTodoChanged;

  UserWidget({Key? key, required this.taskData, required this.onTodoChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.grey),
          color: Colors.white70),
      margin: EdgeInsets.symmetric(vertical: 1.0),
      child: ListTile(
        leading: Image.asset(
            taskData.isCompleted == false || taskData.isCompleted == null
                ? 'assets/images/in_progress.png'
                : 'assets/images/correct.png'),
        title: Text("Title : " + taskData.title),
        subtitle: Text("Content : " + taskData.content),
        onTap: () {
          onTodoChanged(taskData);
        },
      ),
    );
  }
}
