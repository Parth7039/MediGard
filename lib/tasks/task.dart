import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:medigard/tasks/todo_tile.dart';
import 'database.dart';
import 'dialog_box.dart';

class TaskSchedulePage extends StatefulWidget {
  const TaskSchedulePage({super.key});

  @override
  State<TaskSchedulePage> createState() => _TaskSchedulePageState();
}

class _TaskSchedulePageState extends State<TaskSchedulePage> {

  final _myBox = Hive.box('myBox');
  ToDoDatabase db = ToDoDatabase();
  @override
  void initState() {
    if(_myBox.get("TODOLIST") == null){
      db.createInitialData();
    }
    else{
      db.loadData();
    }

    super.initState();
  }

  final _controller = TextEditingController();



  void checkBoxChanged(bool? value, int index){
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDatabase();
  }

  void saveNewTask(){
    setState(() {
      db.toDoList.add([_controller.text,false]);
    });
    db.updateDatabase();
    _controller.clear();
    Navigator.of(context).pop();
  }

  void createNewTask(){
    showDialog(context: context, builder: (context){
      return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () {
            _controller.clear();
            Navigator.of(context).pop();
          }
      );
    });
  }

  void deleteTask(int index){
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red.shade200,
        appBar: AppBar(
          title: Text('To-Do'),
          backgroundColor: Colors.red.shade400,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            createNewTask();
          },
          child: Icon(Icons.add_circle_outlined,size: 30,),
        ),
        body: ListView.builder(
          itemCount: db.toDoList.length,
          itemBuilder: (context, index){
            return ToDoTile(
              taskName: db.toDoList[index][0],
              taskCompleted: db.toDoList[index][1],
              onChanged: (value) => checkBoxChanged(value, index),
              deleteFunction: (context) => deleteTask(index),
            );
          },
        )
    );
  }
}
