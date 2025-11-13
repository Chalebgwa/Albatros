# AR Implementation Guide

This document describes how to integrate AR functionality with the Albatros AR Quiz application.

## Current Implementation

The app currently uses a **demo mode** where users can select landmarks from a list. This allows testing the quiz, badge, and mission systems without requiring AR hardware.

## AR Plugin: ar_flutter_plugin

The project is configured to use `ar_flutter_plugin` for AR functionality on both iOS and Android.

### Features Supported

- **ARKit** (iOS): Apple's AR framework for iOS devices
- **ARCore** (Android): Google's AR platform for Android devices
- **Object Recognition**: Detect and track real-world objects
- **Image Recognition**: Recognize specific images/landmarks

## Integration Steps

### 1. Basic AR View Implementation

To implement actual AR scanning, replace the placeholder in `lib/screens/ar_view_screen.dart`:

```dart
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';

// Initialize AR session
ARSessionManager? arSessionManager;
ARObjectManager? arObjectManager;

Widget buildARView() {
  return ARView(
    onARViewCreated: onARViewCreated,
    planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
  );
}

void onARViewCreated(
  ARSessionManager arSessionManager,
  ARObjectManager arObjectManager,
  ARAnchorManager arAnchorManager,
  ARLocationManager arLocationManager,
) {
  this.arSessionManager = arSessionManager;
  this.arObjectManager = arObjectManager;
  
  arSessionManager.onInitialize(
    showFeaturePoints: false,
    showPlanes: true,
    handleTaps: true,
  );
}
```

### 2. Image Recognition Setup

For landmark recognition, you need to:

1. **Prepare Reference Images**: Create a set of reference images for each landmark
2. **Configure AR Session**: Set up image tracking
3. **Handle Detection Events**: Process detected landmarks

```dart
// Add reference images to assets
// Update pubspec.yaml:
// flutter:
//   assets:
//     - assets/ar_images/eiffel_tower.jpg
//     - assets/ar_images/statue_of_liberty.jpg

// Configure image tracking
arSessionManager.onInitialize(
  customPlaneTexturePath: "assets/triangle.png",
  showFeaturePoints: false,
  showPlanes: false,
  handleTaps: false,
);

// Listen for image detection
arSessionManager.onPlaneOrPointTap = (taps) {
  // Handle tap on detected image
  detectLandmark(taps);
};
```

### 3. ML-Based Recognition

For more accurate landmark recognition, integrate TensorFlow Lite:

```dart
import 'package:tflite_flutter/tflite_flutter.dart';

class LandmarkRecognitionService {
  Interpreter? _interpreter;
  
  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('landmarks_model.tflite');
  }
  
  Future<Landmark?> recognizeImage(CameraImage image) async {
    // Preprocess image
    final input = preprocessImage(image);
    
    // Run inference
    final output = List.filled(5, 0.0).reshape([1, 5]);
    _interpreter?.run(input, output);
    
    // Get highest confidence landmark
    return getLandmarkFromPrediction(output);
  }
}
```

### 4. Camera Integration

The app already includes the `camera` package. To use it:

```dart
import 'package:camera/camera.dart';

class ARViewScreen extends StatefulWidget {
  @override
  State<ARViewScreen> createState() => _ARViewScreenState();
}

class _ARViewScreenState extends State<ARViewScreen> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  
  @override
  void initState() {
    super.initState();
    initCamera();
  }
  
  Future<void> initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(
      cameras![0],
      ResolutionPreset.high,
      enableAudio: false,
    );
    await controller?.initialize();
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    
    return CameraPreview(controller!);
  }
}
```

## Platform-Specific Configuration

### iOS (ARKit)

Requirements are already configured in `ios/Runner/Info.plist`:
- Camera usage permission
- ARKit capability
- Location permission (optional, for location-based features)

Minimum iOS version: 11.0 (for ARKit)

### Android (ARCore)

Requirements are already configured in `android/app/src/main/AndroidManifest.xml`:
- Camera permission
- ARCore feature (optional)
- Location permission (optional)

Minimum Android version: 7.0 (API level 24)

## Testing AR Features

### Testing on Physical Devices

1. **iOS**: Deploy to iPhone 6S or later with iOS 11+
2. **Android**: Deploy to ARCore-supported device

### Testing Without AR Hardware

The app includes a **demo mode** that works without AR:
- Select landmarks from a list
- Test quiz functionality
- Validate badge and mission systems

## Future Enhancements

### Recommended Improvements

1. **Custom ML Model**
   - Train a TensorFlow Lite model on landmark images
   - Improve recognition accuracy
   - Support more landmarks

2. **Location-Based Detection**
   - Use GPS to pre-filter possible landmarks
   - Provide context-aware quizzes
   - Show nearby landmarks on a map

3. **3D Models**
   - Add 3D landmark models for AR visualization
   - Display information overlays in AR
   - Interactive AR elements

4. **Social Features**
   - Share landmark discoveries
   - Compare progress with friends
   - Collaborative quizzes

## Resources

- [ar_flutter_plugin Documentation](https://pub.dev/packages/ar_flutter_plugin)
- [ARKit Developer Guide](https://developer.apple.com/arkit/)
- [ARCore Developer Guide](https://developers.google.com/ar)
- [TensorFlow Lite Guide](https://www.tensorflow.org/lite)
- [Flutter Camera Plugin](https://pub.dev/packages/camera)

## Troubleshooting

### Common Issues

1. **AR not initializing**
   - Check device compatibility
   - Verify permissions are granted
   - Ensure proper lighting conditions

2. **Poor recognition accuracy**
   - Improve reference image quality
   - Train custom ML model
   - Adjust detection thresholds

3. **Performance issues**
   - Reduce image processing resolution
   - Optimize ML model
   - Limit frame processing rate

## Support

For issues or questions:
- Check the GitHub repository issues
- Review Flutter documentation
- Consult AR plugin documentation
