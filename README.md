# Albatros - AR Quiz Application

A Flutter-based AR quiz application that runs on both iOS and Android. The app detects landmarks using AR technology, displays quiz questions, awards digital badges for correct answers, and includes a streak/mission system for engagement.

## Features

### 🎯 Core Features
- **AR Landmark Detection**: Uses AR technology to identify famous landmarks (with demo mode for testing)
- **Interactive Quizzes**: Answer questions about detected landmarks and earn points
- **Digital Badges**: Collect badges for achievements, streaks, and landmark discoveries
- **Mission System**: Complete daily, weekly, and special missions for bonus rewards
- **Streak Tracking**: Maintain your learning streak with consecutive days of activity

### 🏛️ Available Landmarks
- Eiffel Tower (Paris, France)
- Statue of Liberty (New York, USA)
- Great Wall of China
- Taj Mahal (Agra, India)
- Colosseum (Rome, Italy)

### 🎖️ Badge Types
- **Achievement Badges**: First Discovery, Perfect Score, Century Club
- **Streak Badges**: 3-Day Streak, Week Warrior
- **Landmark Badges**: Explorer, Globe Trotter
- **Master Badges**: Quiz Master (500+ points)

### 🎯 Mission Types
- **Daily Missions**: Quick daily challenges
- **Weekly Missions**: Long-term goals
- **Special Missions**: Unique achievement challenges
- **Landmark Missions**: Discover specific landmarks

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── landmark.dart
│   ├── question.dart
│   ├── badge.dart
│   ├── mission.dart
│   └── user_progress.dart
├── services/                 # Business logic
│   ├── storage_service.dart
│   ├── landmark_service.dart
│   ├── badge_service.dart
│   └── mission_service.dart
├── providers/                # State management
│   └── app_provider.dart
└── screens/                  # UI screens
    ├── home_screen.dart
    ├── ar_view_screen.dart
    ├── quiz_screen.dart
    ├── missions_screen.dart
    ├── badges_screen.dart
    └── profile_screen.dart
```

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- iOS: Xcode and iOS device with ARKit support
- Android: Android Studio and device with ARCore support

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Chalebgwa/Albatros.git
cd Albatros
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
# For iOS
flutter run -d ios

# For Android
flutter run -d android
```

## Dependencies

### Core
- `flutter`: Flutter SDK
- `provider`: State management
- `shared_preferences`: Local data persistence
- `path_provider`: File system access

### AR & Image Processing
- `ar_flutter_plugin`: AR functionality
- `camera`: Camera access
- `image`: Image processing
- `tflite_flutter`: TensorFlow Lite for ML

### UI
- `cupertino_icons`: iOS-style icons
- `google_fonts`: Custom fonts

### Utilities
- `uuid`: Unique identifier generation
- `intl`: Internationalization

## How to Use

1. **Launch the App**: Open Albatros on your device
2. **AR Scan**: Point your camera at a landmark or select from the demo list
3. **Answer Quiz**: Answer the question about the detected landmark
4. **Earn Rewards**: Collect points, badges, and complete missions
5. **Track Progress**: View your stats, badges, and achievements in the Profile tab

## Architecture

### State Management
Uses the **Provider** pattern for reactive state management across the app.

### Data Persistence
User progress, badges, and missions are stored locally using **SharedPreferences**.

### AR Implementation
The app is structured to use `ar_flutter_plugin` for AR features. In demo mode, users can select landmarks manually for testing without AR hardware.

## Platform-Specific Features

### iOS
- ARKit integration for AR features
- Camera and location permissions configured
- Optimized for iOS devices with ARKit support

### Android
- ARCore integration for AR features
- Camera and location permissions configured
- Compatible with ARCore-supported devices

## Future Enhancements

- [ ] Implement full AR image recognition with ML models
- [ ] Add multiplayer quiz challenges
- [ ] Integrate real-world location-based landmark detection
- [ ] Add more landmarks and quiz questions
- [ ] Implement leaderboards
- [ ] Add social sharing features
- [ ] Support for custom user-created quizzes

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.

## Credits

Created as part of the Albatros AR Quiz project.