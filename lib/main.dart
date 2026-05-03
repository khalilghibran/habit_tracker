import 'package:flutter/material.dart';
import 'logic/taskhabit_logic.dart'; // task&habit manag

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Habit Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  TextEditingController habitController = TextEditingController();
  TextEditingController todoController = TextEditingController();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      
      body: SingleChildScrollView(
        child: Column(
        children: [

        /// _______________________________HABIT_____________________________________
        SizedBox(height: 20),

        Text("Jumlah air: $air"),
        Padding(
          padding: EdgeInsets.all(16),
          child: TextField(
            controller: habitController,
            decoration: InputDecoration(
              labelText: "Masukkan Habit",
              border: OutlineInputBorder(),
            ),
          ),
        ),

        SizedBox(height: 20),

        ElevatedButton(
          onPressed: () {
            setState(() {
              if (habitController.text.isNotEmpty) {
                tambahHabit(habitController.text);
                habitController.clear();
              }
            });
          },
          child: Text("Tambah Habit"),
        ),

        SizedBox(height: 20),

    // LIST HABIT
       ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: habitList.length,

        itemBuilder: (context, index) {
          return ListTile(
            title: Text(habitList[index].name),
            trailing: Checkbox(
             value: habitList[index].isDone,
             onChanged: (value) {
              setState(() {
              checkHabit(index);
              });
             },
            ),
          );
        },
       ),


       ///______________________________________To Do_______________________________________
       SizedBox(height: 30),

       Text("To-do List", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

       Padding(
         padding: EdgeInsets.all(16),
         child: TextField(
           controller: todoController,
           decoration: InputDecoration(
             labelText: "Masukkan To-do",
             border: OutlineInputBorder(),
            ),
         ),
        ),

       ElevatedButton(
         onPressed: () {
           setState(() {
             if (todoController.text.isNotEmpty) {
               tambahTodo(todoController.text);
               todoController.clear();
              }
          });
        },
        child: Text("Tambah To-do"),
       ),

       SizedBox(height: 10),

       ListView.builder(
         shrinkWrap: true,
         physics: NeverScrollableScrollPhysics(),
         itemCount: todoList.length,
         itemBuilder: (context, index) {
           return ListTile(
             title: Text(todoList[index].title),
             trailing: Checkbox(
               value: todoList[index].isDone,
               onChanged: (value) {
                 setState(() {
                   checkTodo(index);
                 });
               },
              ),
            );
          },
        ),
        ],
       ),
      ),

    );
  }
}