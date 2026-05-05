import 'package:flutter/material.dart';
import '../logic/taskhabit_logic.dart';

class HabitPage extends StatefulWidget {
  const HabitPage({super.key});

  @override
  State<HabitPage> createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  TextEditingController habitController = TextEditingController();

  int selectedIconIndex = 0;
  bool reminder = false;

  List<String> icons = [
    '💧',
    '💪',
    '🧘',
    '📚',
    '☀️',
    '🍵',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1F0F),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1F0F),
        elevation: 0,
        title: const Text(
          "Tambah Habit Baru",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// INPUT NAMA HABIT
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: habitController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Contoh: Minum Air Putih",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1A3A1A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            /// TEXT LABEL
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Ikon Habit",
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 12),

            /// GRID ICON
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: 70, // 🔥 INI KUNCI
              ),
              itemCount: icons.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIconIndex = index;
                    });
                  },
                  child: Container(
                    //width: 70,
                    //height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A3A1A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedIconIndex == index
                            ? Colors.green
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        icons[index],
                        style: const TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            /// TOGGLE REMINDER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A3A1A)..withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Aktifkan Pengingat",
                      style: TextStyle(color: Colors.white),
                    ),
                    Switch(
                      value: reminder,
                      onChanged: (value) {
                        setState(() {
                          reminder = value;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// BUTTON TAMBAH HABIT
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  if (habitController.text.isNotEmpty) {
                    tambahHabit(
                    habitController.text,
                    icons[selectedIconIndex],
                  );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("🌱 Habit berhasil ditambahkan"),
                    duration: Duration(seconds: 1),
                    backgroundColor: Colors.green,
                    ),
                  );

                  Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(color: Colors.green),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Center(
                  child: Text(
                    "+ Tambah Habit Baru",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}