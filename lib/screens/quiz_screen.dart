import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/question.dart';

/// Quiz screen that displays questions about detected landmarks
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int? _selectedAnswer;
  bool _hasAnswered = false;
  bool _isCorrect = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final landmark = provider.currentLandmark;
    final question = provider.currentQuestion;

    if (landmark == null || question == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const Center(
          child: Text('No quiz available'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(landmark.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Landmark Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            landmark.name,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      landmark.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Question
            Text(
              'Question',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              question.questionText,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            
            const SizedBox(height: 24),
            
            // Answer Options
            Expanded(
              child: ListView.builder(
                itemCount: question.options.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildAnswerOption(
                      index,
                      question.options[index],
                      question.correctAnswerIndex,
                    ),
                  );
                },
              ),
            ),
            
            // Explanation (shown after answer)
            if (_hasAnswered)
              Card(
                color: _isCorrect ? Colors.green[50] : Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _isCorrect ? Icons.check_circle : Icons.cancel,
                            color: _isCorrect ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isCorrect ? 'Correct!' : 'Incorrect',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _isCorrect ? Colors.green : Colors.red,
                            ),
                          ),
                          const Spacer(),
                          if (_isCorrect)
                            Text(
                              '+${question.points} points',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        question.explanation,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Action Button
            ElevatedButton(
              onPressed: _hasAnswered ? _finish : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                _hasAnswered ? 'Continue' : 'Select an answer',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerOption(int index, String text, int correctIndex) {
    Color? backgroundColor;
    Color? borderColor;
    Icon? icon;

    if (_hasAnswered) {
      if (index == correctIndex) {
        backgroundColor = Colors.green[100];
        borderColor = Colors.green;
        icon = const Icon(Icons.check, color: Colors.green);
      } else if (index == _selectedAnswer) {
        backgroundColor = Colors.red[100];
        borderColor = Colors.red;
        icon = const Icon(Icons.close, color: Colors.red);
      }
    } else if (_selectedAnswer == index) {
      backgroundColor = Colors.blue[100];
      borderColor = Colors.blue;
    }

    return InkWell(
      onTap: _hasAnswered ? null : () => _selectAnswer(index),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: borderColor ?? Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            if (icon != null) icon,
          ],
        ),
      ),
    );
  }

  void _selectAnswer(int index) async {
    setState(() {
      _selectedAnswer = index;
      _hasAnswered = true;
    });

    final provider = Provider.of<AppProvider>(context, listen: false);
    final isCorrect = await provider.submitAnswer(index);
    
    setState(() {
      _isCorrect = isCorrect;
    });

    // Show badge notification if new badges were earned
    if (isCorrect) {
      _checkForNewBadges();
    }
  }

  void _checkForNewBadges() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    // This is simplified - in production, you'd track which badges are new
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        // Check if any badges were just earned
        // For now, we'll just show a general message
      }
    });
  }

  void _finish() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.clearCurrentQuiz();
    Navigator.pop(context);
  }
}
