import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  //const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  List<String> todoList = <String>[];
  SharedPreferences sharedPreferences;
  @override
  void initState() {
    loadSharedPreferencesAndData();
    super.initState();
  }

  void loadSharedPreferencesAndData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }

  void _deleteTx(int idx) {
    setState(() {
      todoList.removeAt(idx);
    });
    saveData();
  }

  void loadData() {
    List<String> listString = sharedPreferences.getStringList('list');
    if (listString != null) {
      todoList = listString.toList();
      setState(() {});
    }
  }

  void saveData() {
    List<String> stringList = todoList.toList();
    sharedPreferences.setStringList('list', stringList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _dialog(context),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: todoList.isEmpty
            ? Center(
                child: Text(
                  "please add a todo",
                  style: TextStyle(color: Colors.black45),
                ),
              )
            : ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: todoList.length,
                itemBuilder: (context, idx) {
                  return ListTile(
                    title: Text(
                      todoList.elementAt(idx),
                      style: TextStyle(fontSize: 22),
                    ),
                    trailing: IconButton(
                      onPressed: () => _deleteTx(idx),
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  );
                }),
      ),
    );
  }

  Future<AlertDialog> _dialog(BuildContext context) async {
    // alter the app state to show a dialog
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a task to your list'),
            content: TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Enter task here'),
            ),
            actions: <Widget>[
              // add button
              ElevatedButton(
                child: const Text('ADD'),
                onPressed: () {
                  setState(() {
                    todoList.add(titleController.text);
                    titleController.clear();
                  });
                  saveData();
                  Navigator.of(context).pop();
                  ;
                },
              ),
              // Cancel button
              ElevatedButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    titleController.clear();
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
