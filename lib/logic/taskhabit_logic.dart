import 'package:flutter/material.dart';

/// Class Habit (simpan data kebiasaan)

class Habit {
  String name;
  bool isDone;
  IconData icon; 

  Habit({
    required this.name,
    this.isDone = false,
    required this.icon,
  });
}

/// Class ToDo ( simpan data tugas)
class Todo {
  String title;
  bool isDone;
  IconData icon; // 🔥 tambahin

  Todo({
    required this.title,
    this.isDone = false,
    required this.icon,
  });
}

/// simpan data

// jumlah habit
List<Habit> habitList = [];

// jumlahtodo
List<Todo> todoList = [];

// simpan jumlah reward air
int air = 0;


//-----------------
/// Function Habit
//-----------------


// new habit ke list
void tambahHabit(String name, IconData icon) {
  habitList.add(
    Habit(name: name, icon: icon),
  );
}

// ceklist habit - index
void checkHabit(int index) {
  if (!habitList[index].isDone) {
    habitList[index].isDone = true; // -> selesai
    tambahAir(); // dapat  reward
  }
}

//-----------------
/// Function Todo
//-----------------

// todo baru
void tambahTodo(String title, IconData icon) {
  todoList.add(
    Todo(title: title, icon: icon),
  );
}

// ceklist todo
void checkTodo(int index) {
  if (!todoList[index].isDone) {
    todoList[index].isDone = true;
    tambahAir(); // tambah reward
  }
}



//-----------------
/// Function Reward
//-----------------

void tambahAir() {
  air++; // airr +1
}
