import 'package:flutter/material.dart';
import '../logic/taskhabit_logic.dart';

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
      appBar: AppBar(
        title: const Text("To-do"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: todoController,
                decoration: const InputDecoration(
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
              child: const Text("Tambah To-do"),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(todoList[index].title),
                  trailing: Checkbox(
                    value: todoList[index].isDone,
                    onChanged: (_) {
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