import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/landmark.dart';
import 'quiz_screen.dart';

/// AR view screen for landmark detection and recognition
/// In production, this would use ar_flutter_plugin for actual AR features
class ARViewScreen extends StatefulWidget {
  const ARViewScreen({super.key});

  @override
  State<ARViewScreen> createState() => _ARViewScreenState();
}

class _ARViewScreenState extends State<ARViewScreen> {
  bool _isScanning = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final landmarks = provider.getAllLandmarks();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Landmark Scanner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfo(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // AR Camera View Placeholder
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.black87,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isScanning ? Icons.camera : Icons.camera_alt_outlined,
                          size: 100,
                          color: Colors.white54,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _isScanning 
                              ? 'Scanning for landmarks...' 
                              : 'Point camera at a landmark',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_isScanning)
                    Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.greenAccent,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Landmarks List (Demo Mode)
          Expanded(
            flex: 1,
            child: Container(
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Demo Mode: Select a landmark',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: landmarks.length,
                      itemBuilder: (context, index) {
                        final landmark = landmarks[index];
                        final isCompleted = provider.userProgress
                            .completedLandmarkIds.contains(landmark.id);
                        
                        return ListTile(
                          leading: Icon(
                            isCompleted 
                                ? Icons.check_circle 
                                : Icons.location_on,
                            color: isCompleted 
                                ? Colors.green 
                                : Colors.blue,
                          ),
                          title: Text(landmark.name),
                          subtitle: Text(landmark.description),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () => _selectLandmark(context, landmark),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleScanning,
        icon: Icon(_isScanning ? Icons.stop : Icons.camera),
        label: Text(_isScanning ? 'Stop' : 'Scan'),
      ),
    );
  }

  void _toggleScanning() {
    setState(() {
      _isScanning = !_isScanning;
    });
    
    // Simulate AR detection after 2 seconds
    if (_isScanning) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && _isScanning) {
          // In production, this would be triggered by actual AR detection
          // For demo, we'll just show a message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Point at a landmark or select from the list below'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      });
    }
  }

  void _selectLandmark(BuildContext context, Landmark landmark) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.setCurrentLandmark(landmark);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QuizScreen(),
      ),
    );
  }

  void _showInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AR Landmark Scanner'),
        content: const Text(
          'This app uses AR technology to recognize famous landmarks. '
          'Point your camera at a landmark, and the app will identify it '
          'and present you with a quiz question.\n\n'
          'In demo mode, you can select landmarks from the list below.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
