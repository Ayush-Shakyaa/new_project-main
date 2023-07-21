import 'package:flutter/material.dart';
import 'package:new_project/model/todo.dart';

import 'database_helper.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}
class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _textEditingController = TextEditingController();
    int completedCount = 0;
  int incompleteCount = 0;
  final List<Todo> _todos = [];
  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() async {
    final todos = await DatabaseHelper.instance.getTodos();
    setState(() {
      _todos.clear();
      _todos.addAll(todos);
    });
  }
  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.completed = !todo.completed;
      if (todo.completed) {
        completedCount++;
        incompleteCount--;
      } else {
        completedCount--;
        incompleteCount++;
      }
    });
  }
  Future<void> _addTodo() async {
    final name = _textEditingController.text.trim();
    if (name.isEmpty) return;
    final newTodo = Todo(id: DateTime.now().millisecondsSinceEpoch, name: name, completed: false);
    await DatabaseHelper.instance.insertTodo(newTodo);
    _textEditingController.clear();
    _loadTodos();
  }

  Future<void> _toggleTodoStatus(int id, String name ,bool completed) async {
    final updatedTodo = Todo(id: id, name: name, completed: !completed);
    await DatabaseHelper.instance.updateTodo(updatedTodo);
    _loadTodos();
  }

  Future<void> _deleteTodo(int id) async {
    await DatabaseHelper.instance.deleteTodo(id);
    _loadTodos();
  }

  Future<void> _updateTodo(int id, String  name, bool completed) async{
    final newTodo = Todo(id: id, name: name, completed: completed);
    await DatabaseHelper.instance.updateTodo(newTodo); 

    _loadTodos();
  } 

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a todo'),
          content: TextFormField(
            controller: _textEditingController,
            decoration: const InputDecoration(hintText: 'Type your todo'),
            autofocus: true,
          ),
          actions: <Widget>[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                print(_textEditingController.text);
               _addTodo();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      floatingActionButton: IconButton(onPressed: _displayDialog, icon: Icon(
        Icons.add
      )),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: FutureBuilder<int?>(
                future: DatabaseHelper.instance.countDoneTodos(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return CircularProgressIndicator();
                  }
                  if(snapshot.hasData)
                  {
                    final int = DatabaseHelper.instance.incomplete();
                    return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Completed: ${snapshot.data}'),
                      ],
                    ),
                  );
                  }
                  if(snapshot.hasError){
                    return Text(snapshot.error.toString());
                  }
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Completed: 0'),
                        Text('Remaining Task: 0'),
                      ],
                    ),
                  );
                }
              ),
            ),
            FutureBuilder<int?>(
          future: DatabaseHelper.instance.incomplete(),
          builder: (context, snapshot) {
            if(snapshot.hasData)
            {
              return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('emaining Task: ${snapshot.data}'),
                ],
              ),
            );
            }
            if(snapshot.hasError){
              return Text(snapshot.error.toString());
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Completed: 0'),
                  Text('Remaining Task: 0'),
                ],
              ),
            );
          }
        ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return ListTile(
                  title: Text(todo.name,
                  style: TextStyle(
                      color: Colors.black
                  )),
                  leading:  Checkbox(
                    value: todo.completed,
                    onChanged: (value) => _toggleTodoStatus(todo.id,todo.name, todo.completed),
                  ),
                  trailing: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: (){
                            _update(todo);
                          },
                          icon: Icon(Icons.edit)),
                        IconButton(
                          onPressed: (){
                            _displayDeleteDailog(todo.id, todo.name);
                          },
                          icon: Icon(Icons.delete)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
              ],
      ),
    );
  }

  Future<void> _update(Todo todo) async {
    TextEditingController _updateName =TextEditingController(text: todo.name);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('update a todo'),
          content: TextFormField(
            // initialValue: name,
            controller: _updateName,
            decoration: const InputDecoration(hintText: 'Type your todo'),
            autofocus: true,
          ),
          actions: <Widget>[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: ()async {
                // print(_textEditingController.text);
              //  _addTodo();
              // _updateTodo(id, name, completed);
                todo.name = _updateName.text;
                await DatabaseHelper.instance.updateTodo(todo);
                _loadTodos();
                Navigator.of(context).pop();
              },
              child: const Text('update'),
            ),
          ],
        );
      },
    );
  }
  
 Future<void> _displayDeleteDailog(int id, String name) async {
    return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        icon: Text('Delete Todo'),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: <Widget>[
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              _deleteTodo(id);
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
}


  }
  









