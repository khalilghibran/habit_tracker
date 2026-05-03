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
  TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text('Input Mood', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bagaimana perasaanmu?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Mood selection buttons
              _buildMoodSelector(),
              const SizedBox(height: 24),
              // Notes section
              const Text(
                'Catatan Opsional',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText:
                      'Ada hal khusus yang memengaruhi mood kamu hari ini?',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                  filled: true,
                  fillColor: Colors.grey[800],
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 24),
              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedMood != null ? _submitMood : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Catat Mood',
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? Colors.green : Colors.grey[700]!,
                    width: isSelected ? 3 : 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: isSelected ? Colors.grey[700] : Colors.transparent,
                ),
                child: Text(
                  mood.$3,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                mood.$2,
                style: TextStyle(
                  color: isSelected ? Colors.green : Colors.grey,
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

    // Get mood response
    final response = moodLogic.getMoodResponse(_selectedMood!);

    if (mounted) {
      // Show feedback dialog
      _showMoodFeedbackDialog(response);
    }
  }

  void _showMoodFeedbackDialog(MoodResponse response) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[800],
        title: Row(
          children: [
            Text(
              response.getIcon(),
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                response.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          response.message,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to home
            },
            child: const Text(
              'Kembali ke Dashboard',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
