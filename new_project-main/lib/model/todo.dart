class Todo {
  int id;
  String name;
  bool completed;
  
  Todo({
    required this.id,
    required this.name,
    required this.completed,
    
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'completed': completed ? 1 : 0,
    };
  }
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] ?? '',
      name: map['name'],
      completed: map['completed'] == 1,
    );
  }
}




