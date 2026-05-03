# Mood & Sleep Features Implementation Guide

## Overview
This guide covers the implementation of Mood and Sleep tracking features for your RutinKu app, based on the flowchart provided.

## Files Created

### Models

#### 1. **models/mood_model.dart**
- `MoodType` enum: 5 mood types (senang, baik, biasa, sedih, buruk)
- `MoodEntry` class: Individual mood entries with emoji support
- `MoodResponseType` enum: motivation, appreciation, neutral
- `MoodResponse` class: Response messages based on mood type

#### 2. **models/sleep_model.dart**
- `SleepEntry` class: Sleep entries with duration and reward tracking
- `SleepTarget` class: Daily sleep target configuration

### Logic

#### 3. **logic/mood_logic.dart** (Enhanced)
- `addMoodEntry()`: Add new mood entries
- `getMoodResponse()`: Get motivation/appreciation messages
- `isMoodPositive()`: Check if mood is positive (senang, baik)
- `isMoodNegative()`: Check if mood is negative (sedih, buruk)

**Motivation Messages** (Negative moods - sedih, buruk):
```
- "Sedih adalah bagian dari hidup. Hal ini akan berlalu. 💪"
- "Ambil napas dalam dan ingat hal-hal yang membuat Anda tersenyum. 😊"
- "Waktu yang sulit tidak berlangsung selamanya. Ini akan membaik! 🌟"
- "Hubungi seseorang yang Anda sayangi. Mereka ingin membantu."
```

**Appreciation Messages** (Positive moods - senang, baik):
```
- "Senang mendengar Anda tersenyum! Nikmati momen ini! 😄"
- "Kebahagiaan Anda menginspirasi orang-orang di sekitar Anda!"
- "Hebat! Anda memiliki energi positif hari ini! 😊"
- "Terus pertahankan semangat positif ini! ✨"
```

#### 4. **logic/sleep_logic.dart**
- `addSleepEntry()`: Add sleep entry and check if target is met
- `setSleepTarget()`: Set custom sleep target (default 8 hours)
- `getWeeklySleepHistory()`: Get sleep entries for a week
- `getSleepCompliancePercentage()`: Calculate compliance with target
- `SleepQualityStatus` enum: good, fair, poor
- `SleepRewardResult` class: Reward information

**Reward System**:
- ✅ If sleep ≥ target: +1 Air (💧 reward)
- ❌ If sleep < target: No reward

### Screens

#### 5. **screens/mood_input_screen.dart**
- Mood selection with emojis
- Optional notes field
- Automatic motivation/appreciation feedback dialog
- Returns to dashboard after submission

**Flow**:
1. User selects mood
2. User can add optional notes
3. Click "Catat Mood" button
4. Get motivation (if negative) or appreciation (if positive) message
5. Return to dashboard

#### 6. **screens/sleep_input_screen.dart**
- Sleep duration slider (0-12 hours)
- Manual input option
- Real-time target comparison
- Reward display widget
- Water reward counter

**Flow**:
1. User sets sleep duration (slider or manual input)
2. System checks: Tidur Cukup? (Is sleep enough?)
3. If YES: Show +1 Air reward with animation
4. If NO: Show "Tidak dapat reward" message
5. Return to dashboard

## Setup Instructions

### Step 1: Update main.dart
```dart
import 'logic/mood_logic.dart';
import 'logic/sleep_logic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MoodLogic()),
        ChangeNotifierProvider(create: (context) => SleepLogic()),
      ],
      child: MaterialApp(
        title: 'RutinKu',
        theme: ThemeData.dark(),
        home: const YourHomeScreen(),
      ),
    );
  }
}
```

### Step 2: Add to pubspec.yaml
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
```

## Usage Examples

### Adding a Mood Entry
```dart
final moodLogic = context.read<MoodLogic>();
final moodEntry = MoodEntry(
  dateTime: DateTime.now(),
  mood: MoodType.senang,
  notes: 'Hari yang bagus!',
);
await moodLogic.addMoodEntry(moodEntry);

// Get response
final response = moodLogic.getMoodResponse(MoodType.senang);
print(response.message); // "Senang mendengar Anda tersenyum! ..."
```

### Adding a Sleep Entry
```dart
final sleepLogic = context.read<SleepLogic>();
final sleepEntry = SleepEntry(
  dateTime: DateTime.now(),
  durationInHours: 8.5,
);

final reward = await sleepLogic.addSleepEntry(sleepEntry);
print(reward.rewardMessage); // "+1 Air (reward)!" or "Tidak dapat reward"
print(reward.waterRewardCount); // Total rewards earned
```

### Setting Sleep Target
```dart
final sleepLogic = context.read<SleepLogic>();
sleepLogic.setSleepTarget(7.5); // Set to 7.5 hours
```

### Getting Sleep Statistics
```dart
final sleepLogic = context.read<SleepLogic>();
final weeklyHistory = sleepLogic.getWeeklySleepHistory(weekStartDate);
final avgSleep = sleepLogic.getWeeklyAverageSleep(weekStartDate);
final compliance = sleepLogic.getSleepCompliancePercentage(weekStartDate);
```

## Mood Types

| Type | Emoji | Label | Response |
|------|-------|-------|----------|
| senang | 😄 | Senang | Appreciation |
| baik | 😊 | Baik | Appreciation |
| biasa | 😐 | Biasa | Neutral |
| sedih | 😔 | Sedih | Motivation |
| buruk | 😢 | Buruk | Motivation |

## Integration with Dashboard

### Navigation Example
```dart
// From dashboard, navigate to mood input
GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MoodInputScreen()),
    );
  },
  child: _buildNavItem('😊 Input Mood'),
)

// From dashboard, navigate to sleep input
GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SleepInputScreen()),
    );
  },
  child: _buildNavItem('😴 Input Sleep'),
)
```

## Features Included

✅ **Mood Tracking** with motivasi/appreciation feedback
✅ **Sleep Duration Tracking** with slider & manual input
✅ **Reward System** (+1 Air for meeting sleep target)
✅ **Target Comparison** Real-time check if sleep is enough
✅ **History Tracking** Weekly/Monthly mood and sleep history
✅ **Statistics** Sleep compliance percentage and average duration
✅ **Response Messages** Contextual feedback based on mood type

## Notes

- Both features use Provider for state management
- Messages for motivation/appreciation are randomized daily
- Sleep target defaults to 8 hours but is customizable
- All entries include timestamp for accurate tracking
- Water rewards accumulate throughout the period
