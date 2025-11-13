# Contributing to Albatros

Thank you for your interest in contributing to Albatros! This document provides guidelines and information for contributors.

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Git
- For iOS development: Xcode and macOS
- For Android development: Android Studio
- Familiarity with Dart and Flutter

### Setting Up Development Environment

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/Albatros.git
   cd Albatros
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Verify setup:
   ```bash
   flutter doctor
   flutter test
   ```

## Development Guidelines

### Code Style

- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

The project uses `flutter_lints` for code analysis. Run:
```bash
flutter analyze
```

### Project Structure

```
lib/
├── main.dart              # App entry point
├── models/                # Data models
├── services/              # Business logic
├── providers/             # State management
├── screens/               # UI screens
└── widgets/               # Reusable widgets (future)
```

### Commit Messages

Use clear, descriptive commit messages:
- `feat: Add new badge type for perfect scores`
- `fix: Correct streak calculation logic`
- `docs: Update README with installation steps`
- `test: Add tests for mission service`
- `refactor: Simplify landmark recognition logic`

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported
2. Create a new issue with:
   - Clear, descriptive title
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots if applicable
   - Device and OS information

### Suggesting Features

1. Check existing issues and pull requests
2. Create an issue describing:
   - The problem you're trying to solve
   - Your proposed solution
   - Any alternatives you've considered
   - Mockups or examples if applicable

### Submitting Pull Requests

1. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes following the guidelines above

3. Add tests for new functionality:
   ```bash
   flutter test
   ```

4. Ensure code passes analysis:
   ```bash
   flutter analyze
   ```

5. Commit your changes with clear messages

6. Push to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

7. Create a Pull Request with:
   - Clear title and description
   - Reference to related issues
   - Screenshots for UI changes
   - Test results

## Areas for Contribution

### High Priority

1. **AR Implementation**
   - Integrate ar_flutter_plugin
   - Implement image recognition
   - Add AR object placement

2. **ML Model Training**
   - Create landmark recognition model
   - Train with landmark images
   - Optimize for mobile

3. **More Landmarks**
   - Add new landmarks
   - Create quiz questions
   - Find reference images

### Medium Priority

4. **UI/UX Improvements**
   - Animations and transitions
   - Better error handling
   - Loading states
   - Accessibility features

5. **Additional Features**
   - Multiplayer mode
   - Leaderboards
   - Social sharing
   - Achievement animations

6. **Testing**
   - Integration tests
   - Widget tests
   - E2E tests

### Documentation

7. **Documentation**
   - API documentation
   - Code comments
   - Tutorial videos
   - Localization

## Testing Guidelines

### Unit Tests

Test all business logic in services:
```dart
test('Should award points for correct answer', () {
  // Arrange
  final service = QuizService();
  
  // Act
  final points = service.calculatePoints(isCorrect: true);
  
  // Assert
  expect(points, 10);
});
```

### Widget Tests

Test UI components:
```dart
testWidgets('Badge card shows correct information', (tester) async {
  await tester.pumpWidget(BadgeCard(badge: testBadge));
  expect(find.text('Test Badge'), findsOneWidget);
});
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/quiz_service_test.dart

# Run with coverage
flutter test --coverage
```

## Code Review Process

All submissions require review. We'll look for:

1. **Functionality**
   - Does it work as intended?
   - Are edge cases handled?

2. **Code Quality**
   - Follows style guidelines
   - Well-documented
   - No unnecessary complexity

3. **Testing**
   - Adequate test coverage
   - Tests pass

4. **Performance**
   - No performance regressions
   - Efficient algorithms

## Adding New Landmarks

To add a new landmark:

1. **Add to LandmarkService**:
   ```dart
   Landmark(
     id: 'landmark_6',
     name: 'Big Ben',
     description: 'Clock tower in London',
     imagePath: 'assets/landmarks/big_ben.jpg',
     recognitionKeywords: ['big ben', 'london', 'clock tower'],
     latitude: 51.5007,
     longitude: -0.1246,
   )
   ```

2. **Add Quiz Questions**:
   ```dart
   Question(
     id: 'q6',
     landmarkId: 'landmark_6',
     questionText: 'In which year was Big Ben completed?',
     options: ['1856', '1859', '1862', '1865'],
     correctAnswerIndex: 1,
     points: 10,
     explanation: 'Big Ben was completed in 1859.',
   )
   ```

3. **Add Reference Image**:
   - Place image in `assets/landmarks/`
   - Update `pubspec.yaml` if needed

4. **Add Tests**:
   - Test landmark retrieval
   - Test question association

## Adding New Badge Types

1. **Add to BadgeService**:
   ```dart
   Badge(
     id: 'badge_new_achievement',
     name: 'Achievement Name',
     description: 'Achievement description',
     iconPath: 'assets/badges/icon.png',
     type: BadgeType.achievement,
     requiredPoints: 100,
   )
   ```

2. **Update Award Logic**:
   ```dart
   case 'badge_new_achievement':
     shouldAward = /* your condition */;
     break;
   ```

3. **Add Tests**:
   ```dart
   test('Should award new badge when condition met', () {
     // test implementation
   });
   ```

## Questions?

Feel free to:
- Open an issue for questions
- Join discussions on existing issues
- Reach out to maintainers

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (MIT License).

---

Thank you for contributing to Albatros! 🎉
