import 'package:habit_tracker/logic/mood_logic.dart';
import 'package:habit_tracker/logic/sleep_logic.dart';

class ReportLogic {
  final MoodLogic moodLogic;
  final SleepLogic sleepLogic;

  // Data habit & todo dari taskhabit_logic (pakai data global)
  final List habitList;
  final List todoList;

  ReportLogic({
    required this.moodLogic,
    required this.sleepLogic,
    required this.habitList,
    required this.todoList,
  });

  // ── Hitung persentase habit selesai minggu ini ───────────
  int getHabitPersenMingguIni() {
    if (habitList.isEmpty) return 0;
    final selesai = habitList.where((h) => h.isDone == true).length;
    return ((selesai / habitList.length) * 100).round();
  }

  // ── Hitung jumlah todo selesai ───────────────────────────
  Map<String, int> getTodoProgress() {
    final selesai = todoList.where((t) => t.isDone == true).length;
    return {
      'selesai': selesai,
      'total': todoList.length,
    };
  }

  // ── Mood dominan minggu ini ──────────────────────────────
  Map<String, String> getMoodDominan() {
    final report = moodLogic.weeklyReport;
    if (report == null || report.mostFrequentMood == null) {
      return {'emoji': '😐', 'label': 'Belum ada data'};
    }

    final mood = report.mostFrequentMood!;
    final moodMap = {
      'senang': {'emoji': '😄', 'label': 'Sangat Senang'},
      'baik':   {'emoji': '😊', 'label': 'Baik'},
      'biasa':  {'emoji': '😐', 'label': 'Biasa'},
      'sedih':  {'emoji': '😕', 'label': 'Sedih'},
      'buruk':  {'emoji': '😢', 'label': 'Buruk'},
    };

    final key = mood.toString().split('.').last;
    return moodMap[key] ?? {'emoji': '😐', 'label': 'Biasa'};
  }

  // ── Rata-rata tidur minggu ini ───────────────────────────
  double getRataRataTidur() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return sleepLogic.getWeeklyAverageSleep(startOfWeek);
  }

  // ── Wawasan otomatis berdasarkan data ────────────────────
  String getWawasan() {
    final habitPersen = getHabitPersenMingguIni();
    final mood = getMoodDominan()['label'] ?? 'Biasa';
    final tidur = getRataRataTidur();

    if (habitPersen >= 80) {
      return 'Kamu konsisten minggu ini! Mood $mood mendukung produktivitasmu. Terus jaga ritme ini 🌟';
    } else if (tidur < 6) {
      return 'Tidurmu kurang dari 6 jam rata-rata minggu ini. Coba istirahat lebih awal untuk hasil lebih baik 😴';
    } else if (habitPersen < 50) {
      return 'Semangat! Masih ada waktu untuk menyelesaikan habit minggu ini. Kamu bisa! 💪';
    } else {
      return 'Kamu sudah melakukan hal yang baik minggu ini. Pertahankan konsistensimu! 🌿';
    }
  }

  // ── Ambil semua data report sekaligus ────────────────────
  Map<String, dynamic> getReportData() {
    return {
      'habitPersen': getHabitPersenMingguIni(),
      'todoProgress': getTodoProgress(),
      'moodDominan': getMoodDominan(),
      'rataRataTidur': getRataRataTidur(),
      'wawasan': getWawasan(),
    };
  }
}