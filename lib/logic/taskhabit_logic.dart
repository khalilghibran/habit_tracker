import 'package:habit_tracker/logic/plant_logic.dart';

/// Class Habit (simpan data kebiasaan)

class Habit {
  String name;
  bool isDone;
  String icon; 

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
  String icon;

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
Future<void> tambahHabit(String name, String icon) async {
  habitList.add(
    Habit(name: name, icon: icon),
  );
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
Future<void> tambahTodo(String title, String icon) async {
  todoList.add(
    Todo(title: title, icon: icon),
  );
}

// ceklist todo
Future<void> checkTodo(int index) async {
  if (!todoList[index].isDone) {
    todoList[index].isDone = true;
    await tambahAir(1);
  }
}


//-----------------
/// Function Reward
//-----------------

Future<void> tambahAir(int amount) async {
  air += amount;
  await PlantLogic.addWaterReward(amount);
}

