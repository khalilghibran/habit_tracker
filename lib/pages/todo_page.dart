import 'package:flutter/material.dart';
import '../logic/taskhabit_logic.dart';
import 'habit_page.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  TextEditingController todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1F0F),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1F0F),
        elevation: 0,
        title: const Text(
          "To Do",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HEADER (RutinKu + Air)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "RutinKu",
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A3A1A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "💧 $air",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            /// INPUT TODO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: todoController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Masukkan To-do",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1A3A1A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// BUTTON TAMBAH TODO
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (todoController.text.isNotEmpty) {
                    tambahTodo(
                      todoController.text,
                      '📝',
                    );

                todoController.clear();

                setState(() {});

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("✅ To-do berhasil ditambahkan"),
                    duration: Duration(seconds: 1),
                    backgroundColor: Colors.green,
                    ),
                  );
                 }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text("Tambah To-do"),
              ),
            ),

            const SizedBox(height: 20),

            /// LIST TODO
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                final item = todoList[index];

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: item.isDone
                      ? const Color.fromARGB(255, 17, 81, 32)
                      : const Color(0xFF1A3A1A),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    
                    child: Row(
                      children: [

                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D1F0F),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          item.icon,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),  

                      const SizedBox(width: 10),

                      Checkbox(
                        value: item.isDone,
                        onChanged: (_) async {
                          await checkTodo(index);

                          setState(() {});

                           ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("+1 💧 Air didapat!"),
                              duration: Duration(milliseconds: 800),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        activeColor: Colors.green,
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            color: Colors.white,
                            decoration:
                            item.isDone ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),

                      const Text("+1💧", style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: const [
                  Text(
                    "Habit",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Divider(color: Colors.white24),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: habitList.length,
              itemBuilder: (context, index) {
                final habit = habitList[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: habit.isDone
                      ? const Color.fromARGB(255, 17, 81, 32)
                      : const Color(0xFF1A3A1A),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [

                        Text(
                          habit.icon,
                          style: const TextStyle(fontSize: 20),
                        ),

                        const SizedBox(width: 10),

                        Checkbox(
                          value: habit.isDone,
                          onChanged: (_){
                            setState(() async{
                              await checkHabit(index);

                              setState(() {});

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("+1 💧 Air didapat!"),
                                  duration: Duration(milliseconds: 800),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            });
                          },
                          activeColor: Colors.green,
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            habit.name,
                            style: TextStyle(
                              color: Colors.white,
                              decoration:
                              habit.isDone ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),

                        const Text("+1💧", style: TextStyle(color: Colors.blue)),
                      ],
                    ),
                  );
                },
              ),

            const SizedBox(height: 20),

            /// BUTTON TAMBAH HABIT
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HabitPage()),
                  );

                  setState(() {
                  });
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D1F0F),
                  side: const BorderSide(color: Colors.green, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "+ Tambah Habit Baru",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}