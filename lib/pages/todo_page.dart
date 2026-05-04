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
                  setState(() {
                    if (todoController.text.isNotEmpty) {
                      tambahTodo(
                        todoController.text,
                        '📝',
                      );
                      todoController.clear();
                    }
                  });
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
                      color: const Color(0xFF1A3A1A),
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
                        onChanged: (_) {
                          setState(() {
                            checkTodo(index);
                          });
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

            /// BUTTON TAMBAH HABIT
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HabitPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(color: Colors.green),
                  padding: const EdgeInsets.symmetric(vertical: 16),
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