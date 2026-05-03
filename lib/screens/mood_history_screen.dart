import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/mood_logic.dart';
import '../models/mood_model.dart';

class MoodHistoryScreen extends StatefulWidget {
  const MoodHistoryScreen({Key? key}) : super(key: key);

  @override
  State<MoodHistoryScreen> createState() => _MoodHistoryScreenState();
}

class _MoodHistoryScreenState extends State<MoodHistoryScreen> {
  String _selectedFilter = 'Minggu ini';
  final List<String> _filterOptions = [
    'Minggu ini',
    '7 hari lalu',
    '14 hari lalu',
    '21 hari lalu',
    'Sebulan lalu',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1F0F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'RutinKu',
          style: TextStyle(
            color: Color(0xFF4FE38A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: GestureDetector(
                onTap: _showFilterMenu,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A3A1A),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _selectedFilter,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.unfold_more,
                        color: Color(0xFF8AA79A),
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Riwayat Mood',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Consumer<MoodLogic>(
              builder: (context, moodLogic, _) {
                final entries = moodLogic.moodHistory;
                if (entries.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada riwayat mood',
                      style: TextStyle(
                        color: Color(0xFF8AA79A),
                        fontSize: 14,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    final dayName = _getDayName(entry.dateTime);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A3A1A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Text(
                              entry.mood.getMoodEmoji(),
                              style: const TextStyle(fontSize: 28),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dayName,
                                    style: const TextStyle(
                                      color: Color(0xFF4FE38A),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    entry.mood.getMoodLabel(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _formatTime(entry.dateTime),
                                    style: const TextStyle(
                                      color: Color(0xFF8AA79A),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A3A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Waktu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._filterOptions.map((option) {
              final isSelected = option == _selectedFilter;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFilter = option;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.green.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF4FE38A)
                          : Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF4FE38A),
                          size: 18,
                        )
                      else
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                        ),
                      const SizedBox(width: 10),
                      Text(
                        option,
                        style: TextStyle(
                          color: isSelected
                              ? const Color(0xFF4FE38A)
                              : Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  String _getDayName(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return 'Hari ini';
    if (difference == 1) return 'Kemarin';

    const days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
    ];
    return days[date.weekday % 7];
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
