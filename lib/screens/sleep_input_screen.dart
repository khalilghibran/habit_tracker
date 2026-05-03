import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/sleep_logic.dart';
import '../models/sleep_model.dart';

class SleepInputScreen extends StatefulWidget {
  const SleepInputScreen({Key? key}) : super(key: key);

  @override
  State<SleepInputScreen> createState() => _SleepInputScreenState();
}

class _SleepInputScreenState extends State<SleepInputScreen> {
  final TextEditingController _sleepDurationController = TextEditingController();
  double _selectedDuration = 8.0;
  SleepRewardResult? _rewardResult;

  @override
  void dispose() {
    _sleepDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text('Input Sleep', style: TextStyle(color: Colors.white)),
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
                'Berapa lama tidur Anda?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              // Sleep duration slider
              _buildSleepDurationSelector(),
              const SizedBox(height: 24),
              // Target info
              _buildTargetInfo(),
              const SizedBox(height: 24),
              // Manual input option
              const Text(
                'Atau masukkan durasi tidur (jam)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _sleepDurationController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: 'Contoh: 7.5',
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
                  suffix: const Text(
                    'jam',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      _selectedDuration = double.tryParse(value) ?? _selectedDuration;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitSleep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Catat Tidur',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (_rewardResult != null) ...[
                const SizedBox(height: 24),
                _buildRewardWidget(_rewardResult!),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSleepDurationSelector() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[700]!),
          ),
          child: Column(
            children: [
              Text(
                '${_selectedDuration.toStringAsFixed(1)}',
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'jam',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Slider(
          value: _selectedDuration,
          min: 0,
          max: 12,
          divisions: 24,
          activeColor: Colors.green,
          inactiveColor: Colors.grey[700],
          onChanged: (value) {
            setState(() {
              _selectedDuration = value;
              _sleepDurationController.text = value.toStringAsFixed(1);
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('0h', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text('12h', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTargetInfo() {
    return Consumer<SleepLogic>(
      builder: (context, sleepLogic, _) {
        final targetHours = sleepLogic.sleepTarget.targetHours;
        final isMetTarget = _selectedDuration >= targetHours;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isMetTarget ? Colors.green[900] : Colors.orange[900],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isMetTarget ? Colors.green : Colors.orange,
            ),
          ),
          child: Column(
            children: [
              Text(
                isMetTarget ? 'Tidur Cukup! ✓' : 'Tidur Kurang ✗',
                style: TextStyle(
                  color: isMetTarget ? Colors.green : Colors.orange,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Target tidur Anda: $targetHours jam',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              if (!isMetTarget)
                Text(
                  'Kurang ${(targetHours - _selectedDuration).toStringAsFixed(1)} jam',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRewardWidget(SleepRewardResult result) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: result.isMeetingTarget ? Colors.green[900] : Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: result.isMeetingTarget ? Colors.green : Colors.grey[700]!,
        ),
      ),
      child: Column(
        children: [
          Text(
            result.isMeetingTarget ? '✨ Reward! ✨' : '❌ Tidak Ada Reward',
            style: TextStyle(
              color: result.isMeetingTarget ? Colors.green : Colors.grey,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            result.rewardMessage,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          if (result.isMeetingTarget) ...[
            const SizedBox(height: 8),
            Text(
              'Total Air Rewards: ${result.waterRewardCount} 💧',
              style: const TextStyle(
                color: Colors.cyan,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]
        ],
      ),
    );
  }

  Future<void> _submitSleep() async {
    final sleepLogic = context.read<SleepLogic>();

    // Create sleep entry
    final sleepEntry = SleepEntry(
      dateTime: DateTime.now(),
      durationInHours: _selectedDuration,
    );

    // Add sleep entry and get reward result
    final result = await sleepLogic.addSleepEntry(sleepEntry);

    setState(() {
      _rewardResult = result;
    });

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.rewardMessage),
          backgroundColor:
              result.isMeetingTarget ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
