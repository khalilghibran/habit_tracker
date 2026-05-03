import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/mood_logic.dart';
import '../models/mood_model.dart';

class MoodInputScreen extends StatefulWidget {
  const MoodInputScreen({Key? key}) : super(key: key);

  @override
  State<MoodInputScreen> createState() => _MoodInputScreenState();
}

class _MoodInputScreenState extends State<MoodInputScreen> {
  MoodType? _selectedMood;
  final TextEditingController _notesController = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  String _getMoodEmoji(MoodType mood) {
    switch (mood) {
      case MoodType.senang:
        return '😄';
      case MoodType.baik:
        return '😊';
      case MoodType.biasa:
        return '😐';
      case MoodType.sedih:
        return '😔';
      case MoodType.buruk:
        return '😢';
    }
  }

  Future<void> _submitMood() async {
    if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih mood terlebih dahulu')),
      );
      return;
    }

    final moodLogic = context.read<MoodLogic>();

    // Create mood entry
    final moodEntry = MoodEntry(
      dateTime: DateTime.now(),
      mood: _selectedMood!,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );

    // Add mood entry
    await moodLogic.addMoodEntry(moodEntry);

    setState(() {
      _submitted = true;
    });

    // Show success message then go back
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.pop(context);
    }
  }

  String _getMoodMessage(MoodType mood) {
    switch (mood) {
      case MoodType.senang:
        return 'Senang mendengarnya! Pertahankan energi positifmu dan nikmati hari ini! 🌟';
      case MoodType.baik:
        return 'Bagus! Lanjutkan momentum positifmu dan buat yang terbaik dari hari ini! 💪';
      case MoodType.biasa:
        return 'Ada apa dengan kamu Tenang, jalani saja pelan-pelan. Kamu lebih kuat dari yang kamu bayangkan, semangattt!! 🌿';
      case MoodType.sedih:
        return 'Maaf mendengarnya. Ingat, perasaan ini hanya sementara. Ambil waktu untuk diri sendiri dan cari bantuan jika diperlukan 💙';
      case MoodType.buruk:
        return 'Hari ini sulit, tapi Anda tidak sendirian. Berbicara dengan seseorang atau istirahat bisa membantu. Kami di sini untuk Anda 🤝';
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
      ),
      body: _submitted ? _buildSuccessState() : _buildInputState(),
    );
  }

  Widget _buildInputState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Bagaimana perasaanmu?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Emosi kamu memandu pertumbuhanmu hari ini.',
            style: TextStyle(
              color: Color(0xFF8AA79A),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),

          // Mood Selection
          _buildMoodSelector(),
          const SizedBox(height: 24),

          // Weekly Flow
          _buildWeeklyFlow(),
          const SizedBox(height: 24),

          // Notes section
          const Text(
            'Catatan Opsional',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
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
              controller: _notesController,
              style: const TextStyle(color: Colors.white),
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    'Ada hal khusus yang memengaruhi mood kamu\nhari ini?',
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

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedMood != null ? _submitMood : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _selectedMood != null ? const Color(0xFF2D5A27) : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Catat Mood',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          // Success message
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A3A1A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mood kamu berhasil disimpan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getMoodMessage(_selectedMood!),
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
          const SizedBox(height: 40),
          // Big emoji
          Center(
            child: Text(
              _getMoodEmoji(_selectedMood!),
              style: const TextStyle(fontSize: 120),
            ),
          ),
          const SizedBox(height: 40),
          // Weekly Flow
          _buildWeeklyFlow(),
          const SizedBox(height: 40),
          // Back button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D5A27),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Kembali',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodSelector() {
    final moods = [
      (MoodType.senang, 'Senang', '😄'),
      (MoodType.baik, 'Baik', '😊'),
      (MoodType.biasa, 'Biasa', '😐'),
      (MoodType.sedih, 'Sedih', '😔'),
      (MoodType.buruk, 'Buruk', '😢'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: moods.map((mood) {
        final isSelected = _selectedMood == mood.$1;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedMood = mood.$1;
            });
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF4FE38A)
                        : Colors.grey.withOpacity(0.2),
                    width: isSelected ? 2.5 : 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF1A3A1A),
                ),
                child: Text(
                  mood.$3,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                mood.$2,
                style: TextStyle(
                  color:
                      isSelected ? const Color(0xFF4FE38A) : Colors.grey,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWeeklyFlow() {
    final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final dayEmojis = ['😐', '😊', '😐', '😄', '😊', '😐', '😊'];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A3A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Weekly Flow',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                'CONSISTENCY: HIGH',
                style: TextStyle(
                  color: Color(0xFF4FE38A),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(7, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      children: [
                        Text(
                          dayEmojis[index],
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          days[index],
                          style: const TextStyle(
                            color: Color(0xFF8AA79A),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      const Text(
                        '−',
                        style: TextStyle(fontSize: 24, color: Color(0xFF8AA79A)),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Min',
                        style: TextStyle(
                          color: Color(0xFF8AA79A),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
