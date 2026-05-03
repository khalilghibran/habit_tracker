import 'package:flutter/material.dart';
import 'package:habit_tracker/logic/plant_logic.dart';
import 'package:habit_tracker/screens/report_screen.dart';
import 'package:habit_tracker/screens/mood_input_screen.dart';
import 'package:habit_tracker/screens/sleep_input_screen.dart';
import 'package:habit_tracker/logic/taskhabit_logic.dart';

import 'package:habit_tracker/pages/todo_page.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic> _plantInfo = {};
  bool _isLoading = true;

  // Dummy data dulu, nanti diganti data asli dari teman
 int get _habitSelesai => habitList.where((h) => h.isDone == true).length;
 int get _habitTotal => habitList.length;
 int get _todoSelesai => todoList.where((t) => t.isDone == true).length;
 int get _todoTotal => todoList.length;
 int get _streakHari => air; // reward air dari taskhabit_logic

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final info = await PlantLogic.getPlantInfo();
    setState(() {
      _plantInfo = info;
      _isLoading = false;
    });
  }

  Future<void> _siramTanaman() async {
    final berhasil = await PlantLogic.waterPlant();
    if (berhasil) {
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🌿 Tanaman berhasil disiram!'),
            backgroundColor: Color(0xFF2D5A27),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('💧 Air tidak cukup!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  String _getDay() {
    const days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'];
    final now = DateTime.now();
    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1F0F),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ──────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'RutinKu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Streak
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A3A1A),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Text('💧', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 4),
                              Text(
                                '${_plantInfo['waterCount'] ?? 0}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Greeting Card ────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A3A1A),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_getGreeting()}, Sea!',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _getDay(),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          // Streak api
                          Row(
                            children: [
                              Image.asset(
                                'Assets/images/Fire.svg',
                                width: 20,
                                height: 20,
                                errorBuilder: (_, __, ___) =>
                                    const Text('🔥', style: TextStyle(fontSize: 20)),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$_streakHari',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Habit & Todo Progress ────────────────
                    Row(
                      children: [
                        // Habit Harian
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A3A1A),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Habit Harian',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$_habitSelesai / $_habitTotal',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: _habitTotal > 0
                                      ? _habitSelesai / _habitTotal
                                      : 0,
                                  backgroundColor: const Color(0xFF0D1F0F),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.green),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Todo Harian
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A3A1A),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'To-Do Harian',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$_todoSelesai / $_todoTotal',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: _todoTotal > 0
                                      ? _todoSelesai / _todoTotal
                                      : 0,
                                  backgroundColor: const Color(0xFF0D1F0F),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.blue),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // ── Plant Card ───────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A3A1A),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _plantInfo['name'] ?? 'Pohon Harapan',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _plantInfo['stageName'] ?? 'Level 1',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(height: 12),
                          // Gambar pohon
                          Image.asset(
                            'Assets/images/pngwing.com (11) 1.svg',
                            width: 150,
                            height: 150,
                            errorBuilder: (_, __, ___) => const Text(
                              '🌳',
                              style: TextStyle(fontSize: 80),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Info level
                          Text(
                            '${5 - (_plantInfo['waterCount'] ?? 0)} siram lagi ke ${_plantInfo['stageName'] ?? 'Level 2'}',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          // Dot indikator level
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (i) {
                              final level = _plantInfo['growthLevel'] ?? 1;
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: i < level
                                      ? Colors.green
                                      : const Color(0xFF0D1F0F),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 16),
                          // Jumlah air
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('💧',
                                  style: TextStyle(fontSize: 20)),
                              const SizedBox(width: 8),
                              Text(
                                '${_plantInfo['waterCount'] ?? 0}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            'Air tersedia',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(height: 16),
                          // Tombol siram
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _siramTanaman,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2D5A27),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Siram Pohonku',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

      // ── Bottom Navigation Bar ──────────────────────────
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1A3A1A),
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
      onTap: (index) {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TodoPage()),
          );
        } /// fix fungsi todo habit gwa
  else if (index == 2) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MoodInputScreen()),
    );
  } else if (index == 3) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SleepInputScreen()),
    );
  } else if (index == 4) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReportScreen()),
    );
  }
},
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sentiment_satisfied_alt),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bedtime_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '',
          ),
        ],
      ),
    );
  }
}