/// Class Habit (simpan data kebiasaan)

class Habit {
  String name;     // nama habt
  bool isDone;     // status

  Habit(this.name, {this.isDone = false});
}

/// Class ToDo ( simpan data tugas)
class Todo {
  String title;    // nama tugas
  bool isDone;     // status

  Todo(this.title, {this.isDone = false});
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
void tambahHabit(String nama) {
  habitList.add(Habit(nama));
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
void tambahTodo(String title) {
  todoList.add(Todo(title));
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
