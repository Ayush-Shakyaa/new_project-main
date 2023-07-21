import 'package:flutter/material.dart';
import 'package:new_project/todo_screen.dart';

import 'database_helper.dart';
import 'model/todo.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 228, 225, 77)),
        useMaterial3: true,
      ),
      home:  TodoScreen(),
    );
  }
}

// class TodoList extends StatefulWidget {
//   const TodoList({Key? key, required this.title});

//   final String title;

//   @override
//   State<TodoList> createState() => _TodoListState();
// }

// // final List<Todo> _todos = <Todo>[];
// String testName = '';
// TextEditingController _textFieldController = TextEditingController();
//   final TextEditingController _textEditingController = TextEditingController();
//   final List<Todo> _todos = [];

// class _TodoListState extends State<TodoList> {
//   int completedCount = 0;
//   int incompleteCount = 0;
//  @override
//  void initState() {
//     super.initState();
//     _loadTodos();
//   }

//   // void _addTodoItem(String name) {
//   //   setState(() {
//   //     _todos.add(Todo(name: name, completed: false));
//   //     incompleteCount++;
//   //   });
//   //   _textFieldController.clear();
//   // }
//   // DatabaseHelper.insertTodo(name: '', completed: false);
//   void _loadTodos() async {
//     final todos = await DatabaseHelper.instance.getTodos();
//     setState(() {
//       _todos.clear();
//       _todos.addAll(todos);
//     });
//   }
//   Future<void> _addTodo() async {
//     final title = _textEditingController.text.trim();
//     if (title.isEmpty) return;
//     final newTodo = Todo(id: DateTime.now().millisecondsSinceEpoch, name: title, completed : false);
//     await DatabaseHelper.instance.insertTodo(newTodo);
//     _textEditingController.clear();
//     _loadTodos();
//   }
//   Future<void> _toggleTodoStatus(int id, String title ,bool isDone) async {
//     final updatedTodo = Todo(id: id, name: title, completed: !isDone);
//     await DatabaseHelper.instance.updateTodo(updatedTodo);
//     _loadTodos();
//   }
//  Future<void> _deleteTodo(int id) async {
//      await DatabaseHelper.instance.deleteTodo(id);
//      _loadTodos();
//    }
   
//    class _loadTodos {
//    }
//   void _editTodoName(Todo todo, String newName) {
//   setState(() {
//     todo.name = newName;
//   });
// }

//   void _handleTodoChange(Todo todo) {
//     setState(() {
//       todo.completed = !todo.completed;
//       if (todo.completed) {
//         completedCount++;
//         incompleteCount--;
//       } else {
//         completedCount--;
//         incompleteCount++;
//       }
//     });
//   }

//   // void _deleteTodo(Todo todo) {
//   //   setState(() {
//   //     _todos.removeWhere((element) => element.name == todo.name);
//   //     if (todo.completed) {
//   //       completedCount--;
//   //     } else {
//   //       incompleteCount--;
//   //     }
//   //   });
//   // }

//   Future<void> _displayDialog() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Add a todo'),
//           content: TextFormField(
//             controller: _textFieldController,
//             decoration: const InputDecoration(hintText: 'Type your todo'),
//             autofocus: true,
//           ),
//           actions: <Widget>[
//             OutlinedButton(
//               style: OutlinedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               onPressed: () {
//                // _addTodoItem(_textFieldController.text);
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         children: _todos.map((Todo todo) {
//           return TodoItem(
//             todo: todo,
//             onTodoChanged: _handleTodoChange,
//             removeTodo: _deleteTodo(),
//           );
//         }).toList(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _displayDialog(),
//         tooltip: 'Add a Todo',
//         child: const Icon(Icons.add),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Completed: $completedCount'),
//               Text('Remaining Task: $incompleteCount'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TodoItem extends StatelessWidget {
//   TodoItem({
//     required this.todo,
//     required this.onTodoChanged,
//     required this.removeTodo,
//   }) : super(key: ObjectKey(todo));

//   final void Function(Todo todo) onTodoChanged;
//   final Todo todo;
//   final void Function(Todo todo) removeTodo;

//   TextStyle _getTextStyle(bool checked) {
//     if (!checked) return const TextStyle(
//       color: Colors.black54,
//       decoration: TextDecoration.lineThrough,
//     );

//     return const TextStyle(
//       color: Colors.black
//     );
//   }
//     // String newName;


//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: () {
//       },
//       leading: Checkbox(
//         checkColor: Colors.greenAccent,
//         activeColor: Colors.red,
//         value: todo.completed,
//         onChanged: (value) {
//           onTodoChanged(todo);
//         },
//       ),
//       title: Row(children: <Widget>[
//         SizedBox(
//           width: MediaQuery.of(context).size.width * 0.6,
//           child: Expanded(
//             child: EditableText(controller:TextEditingController(text:todo.name),focusNode: FocusNode(), 
//           cursorColor: Colors.black,
//             backgroundCursorColor: Colors.grey,
//             onChanged: (newName){
//             }, style: _getTextStyle(todo.completed),
//           ),
//           ),
//         ),
//         // IconButton(
//         //   iconSize: 30,
//         //   icon: const Icon(
//         //     Icons.edit,
//         //     // color: Colors.red,
//         //   ),
//         //   alignment: Alignment.centerRight,
//         //   onPressed: () {
//         //     // removeTodo(todo);
//         //   },
//         // ),
//         IconButton(
//           iconSize: 30,
//           icon: const Icon(
//             Icons.delete,
//             color: Colors.red,
//           ),
//           alignment: Alignment.centerRight,
//           onPressed: () {
//             removeTodo(todo);
//           },
//         ),
//       ]),
//     );
//   }
// }