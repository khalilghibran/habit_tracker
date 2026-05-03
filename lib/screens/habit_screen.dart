import 'package:flutter/material.dart';
import 'package:habit_tracker/logic/taskhabit_logic.dart';

class HabitScreen extends StatefulWidget {
  const HabitScreen({super.key});

  @override
  State<HabitScreen> createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  final TextEditingController _habitNameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _selectedIcon = '🧘';
  bool _isDaily = true;
  bool _enableReminder = true;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 7, minute: 0);

  final List<String> _iconOptions = [
    '💧', '👟', '🧘', '📖', '🏋',
    '🍎', '🥤', '☀️', '🍵', '⋯',
  ];

  @override
  void dispose() {
    _habitNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _addHabit() async {
    if (_habitNameController.text.isNotEmpty) {
      await tambahHabit(_habitNameController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Habit ditambahkan! Pohon mendapat 💧'),
            backgroundColor: Color(0xFF2D5A27),
          ),
        );
        Navigator.of(context).pop();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon masukkan nama habit terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1F0F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Tambah Habit Baru',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Nama Habit ──────────────────────
            const Text(
              'Nama Habit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A3A1A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _habitNameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Contoh: Minum Air Putih',
                  hintStyle: const TextStyle(
                    color: Color(0xFF8AA79A),
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  suffixText: '0/30',
                  suffixStyle: const TextStyle(
                    color: Color(0xFF8AA79A),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ─── Ikon Habit ──────────────────────
            const Text(
              'Ikon Habit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _iconOptions.length,
              itemBuilder: (context, index) {
                final icon = _iconOptions[index];
                final isSelected = _selectedIcon == icon;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIcon = icon;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A3A1A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.green
                            : Colors.grey.withOpacity(0.2),
                        width: isSelected ? 2 : 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        icon,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // ─── Waktu / Frekuensi ──────────────
            const Text(
              'Waktu / Frekuensi',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isDaily = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A3A1A),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _isDaily
                              ? Colors.green
                              : Colors.grey.withOpacity(0.2),
                          width: _isDaily ? 2 : 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          if (_isDaily)
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            )
                          else
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.4),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          const SizedBox(height: 6),
                          const Text(
                            'Setiap Hari',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            'Lakukan setiap hari',
                            style: TextStyle(
                              color: Color(0xFF8AA79A),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isDaily = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A3A1A),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: !_isDaily
                              ? Colors.green
                              : Colors.grey.withOpacity(0.2),
                          width: !_isDaily ? 2 : 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          if (!_isDaily)
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            )
                          else
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.4),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          const SizedBox(height: 6),
                          const Text(
                            'Kustom',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            'Pilih hari tertentu',
                            style: TextStyle(
                              color: Color(0xFF8AA79A),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ─── Reminder Settings ──────────────
            const Text(
              'Waktu / Frekuensi',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1A3A1A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.notifications,
                        color: Color(0xFF8AA79A),
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Aktifkan Penggigat',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: _enableReminder,
                    onChanged: (value) {
                      setState(() {
                        _enableReminder = value;
                      });
                    },
                    activeColor: Colors.green,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => _selectTime(context),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Color(0xFF8AA79A),
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Waktu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          _selectedTime.format(context),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFF8AA79A),
                          size: 14,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ─── Catatan Opsional ──────────────
            const Text(
              'Catatan Opsional',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1A3A1A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _notesController,
                style: const TextStyle(color: Colors.white),
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Tambahkan catatan untuk habit ini.....',
                  hintStyle: const TextStyle(
                    color: Color(0xFF8AA79A),
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  suffixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Icon(
                      Icons.edit,
                      color: Color(0xFF8AA79A),
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ─── Add Button ─────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addHabit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D5A27),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  '+ Tambah Habit Baru',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
