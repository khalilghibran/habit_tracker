import 'package:flutter/material.dart';
import '../logic/taskhabit_logic.dart';

class HabitPage extends StatefulWidget {
  const HabitPage({super.key});

  @override
  State<HabitPage> createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  TextEditingController habitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Habit"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 20),
            Text("Jumlah air: $air"),

            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: habitController,
                decoration: const InputDecoration(
                  labelText: "Masukkan Habit",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (habitController.text.isNotEmpty) {
                    tambahHabit(habitController.text);
                    habitController.clear();
                  }
                });
              },
              child: const Text("Tambah Habit"),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: habitList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(habitList[index].name),
                  trailing: Checkbox(
                    value: habitList[index].isDone,
                    onChanged: (_) {
                      setState(() {
                        checkHabit(index);
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
