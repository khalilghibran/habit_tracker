# Weekly Report Implementation Guide

## Overview
This guide shows how to implement the weekly mood tracking and report features for your RutinKu app.

## Files Created

### 1. **models/mood_model.dart**
- `MoodType` enum: Represents the 5 mood types (senang, baik, biasa, sedih, buruk)
- `MoodEntry` class: Stores individual mood entries with date, mood type, and optional notes
- Includes helper methods for emoji and labels

### 2. **models/weekly_report_model.dart**
- `DailyMoodStat` class: Daily mood statistics for a specific day
- `WeeklyReport` class: Contains weekly statistics, consistency data, and mood trends

### 3. **logic/mood_logic.dart**
- `MoodLogic` class: Main business logic using ChangeNotifier for state management
- Key methods:
  - `addMoodEntry()`: Add new mood entry
  - `updateWeeklyReport()`: Calculate weekly statistics
  - `getWeeklyMoodHistory()`: Get mood entries for a specific week
  - `getMonthlyMoodHistory()`: Get mood entries for a specific month
  - `getAllMoodHistory()`: Get all mood entries sorted by date

### 4. **screens/weekly_report_screen.dart**
- Sample UI screen showing how to use the mood logic
- Displays weekly flow with consistency indicator
- Shows mood history list

## Setup Instructions

### Step 1: Add Provider to pubspec.yaml
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
```

### Step 2: Wrap your app with ChangeNotifierProvider
In your `main.dart`:

```dart
import 'package:provider/provider.dart';
import 'logic/mood_logic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MoodLogic(),
      child: MaterialApp(
        title: 'RutinKu',
        theme: ThemeData.dark(),
        home: const YourHomeScreen(),
      ),
    );
  }
}
```

### Step 3: Use MoodLogic in your widgets

**Adding a mood entry:**
```dart
final moodLogic = context.read<MoodLogic>();
await moodLogic.addMoodEntry(
  MoodEntry(
    dateTime: DateTime.now(),
    mood: MoodType.senang,
    notes: 'Feeling great today!',
  ),
);
```

**Getting weekly report:**
```dart
Consumer<MoodLogic>(
  builder: (context, moodLogic, _) {
    final weeklyReport = moodLogic.weeklyReport;
    return Text('Consistency: ${weeklyReport?.consistencyPercentage}%');
  },
)
```

**Getting mood history:**
```dart
final moodLogic = context.read<MoodLogic>();
final allMoods = moodLogic.getAllMoodHistory();
final weeklyMoods = moodLogic.getWeeklyMoodHistory(weekStartDate);
```

## Mood Types and Emojis

| Mood Type | Label | Emoji |
|-----------|-------|-------|
| senang    | Senang| 😄    |
| baik      | Baik  | 😊    |
| biasa     | Biasa | 😐    |
| sedih     | Sedih | 😔    |
| buruk     | Buruk | 😢    |

## Features Included

✅ **Mood Tracking**: Record daily moods with timestamps
✅ **Weekly Reports**: Automatic weekly statistics calculation
✅ **Consistency Tracking**: Weekly consistency percentage and level
✅ **Mood History**: View past mood entries
✅ **Monthly/Weekly Filtering**: Get moods for specific periods
✅ **Most Frequent Mood**: Track which mood you experience most
✅ **Day-wise Stats**: See mood for each day of the week

## Example Consistency Levels

- **HIGH**: 80% or more entries recorded
- **MEDIUM**: 50-79% entries recorded
- **LOW**: Less than 50% entries recorded

## Notes

- The app considers Monday as the start of the week
- Day names use Indonesian abbreviations: Sen (Monday), Sel (Tuesday), Rab (Wednesday), etc.
- All mood entries are sorted by most recent first
- The weekly report is automatically updated when you add a new mood
