import 'package:habit_tracker/logic/plant_logic.dart';

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
Future<void> tambahHabit(String nama) async {
  habitList.add(Habit(nama));
  // Reward water untuk menambah habit baru (+1 water)
  await tambahAir(1);
}

// ceklist habit - index
Future<void> checkHabit(int index) async {
  if (!habitList[index].isDone) {
    habitList[index].isDone = true; // -> selesai
    await tambahAir(1); // dapat reward (+1 water per habit completion)
  }
}

//-----------------
/// Function Todo
//-----------------

// todo baru
Future<void> tambahTodo(String title) async {
  todoList.add(Todo(title));
  // Reward water untuk menambah todo baru (+1 water)
  await tambahAir(1);
}

// ceklist todo
Future<void> checkTodo(int index) async {
  if (!todoList[index].isDone) {
    todoList[index].isDone = true;
    await tambahAir(1); // tambah reward (+1 water per todo completion)
  }
}



//-----------------
/// Function Reward
//-----------------

Future<void> tambahAir(int amount) async {
  air += amount;
  // Automatically add water to plant
  await PlantLogic.addWaterReward(amount);
}
