import 'dart:math';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:screenshot/screenshot.dart';
import '../../../core/game/base/game_controller.dart';

class ConnectTheDotsController extends GameController implements Game {
  final ScreenshotController screenshotController = ScreenshotController();
  final List<Offset> points = [];
  final Map<int, Map<String, dynamic>> gameInformation = {};
  final Map<int, Map<String, Offset>> circlePositions = {
    1: {
      '1': const Offset(0.5, 0.2),
      '2': const Offset(0.2, 0.35),
      '3': const Offset(0.45, 0.35),
      '4': const Offset(0.3, 0.5),
      '5': const Offset(0.55, 0.45),
      '6': const Offset(0.7, 0.3),
      '7': const Offset(0.8, 0.4),
      '8': const Offset(0.5, 0.6),
      '9': const Offset(0.8, 0.55),
      '10': const Offset(0.4, 0.75),
    },
    2: {
      '1': const Offset(0.1, 0.2),
      '2': const Offset(0.2, 0.3),
      '3': const Offset(0.3, 0.15),
      '4': const Offset(0.35, 0.5),
      '5': const Offset(0.6, 0.2),
      '6': const Offset(0.65, 0.35),
      '7': const Offset(0.9, 0.2),
      '8': const Offset(0.9, 0.6),
      '9': const Offset(0.8, 0.35),
      '10': const Offset(0.3, 0.8),
    },
    3: {
      '1': const Offset(0.8, 0.7),
      '2': const Offset(0.6, 0.5),
      '3': const Offset(0.8, 0.3),
      '4': const Offset(0.4, 0.35),
      '5': const Offset(0.7, 0.2),
      '6': const Offset(0.1, 0.3),
      '7': const Offset(0.4, 0.6),
      '8': const Offset(0.1, 0.6),
      '9': const Offset(0.25, 0.7),
      '10': const Offset(0.8, 0.8),
    },
  };

  late int circlePositionKey;
  int indexKey = 1;
  bool isFirstTouch = true;
  String? lastEnteredCircle;
  Uint8List? capturedImageBytes;

  late double screenWidth;
  late double screenHeight;

  late String patientId;
  late String patientEmail;
  late String latestDocId;

  final random = Random();

  @override
  String get title => "Connect The Dots";

  @override
  String get info =>
      "Draw a line connecting the dots in increasing numerical order from 1,10. Tap Submit when you are done.";

  @override
  String get route => "/connect-dots";

  @override
  Icon get gameIcon => const Icon(Icons.gesture);

  @override
  void onInit() {
    super.onInit();

    final context = Get.context!;
    final size = MediaQuery.of(context).size;

    screenWidth = size.width;
    screenHeight = size.height;

    patientId = "demo-id";      // Replace with actual logic if needed
    patientEmail = "demo@email.com";  // Replace with actual logic if needed

    resetGame();
  }

  @override
  void resetGame() {
    points.clear();
    gameInformation.clear();
    indexKey = 1;
    isFirstTouch = true;
    lastEnteredCircle = null;
    circlePositionKey = random.nextInt(3) + 1;
  }

  void recordDotInteraction(String? dot, Offset dotPosition, Offset linePosition) {
    DateTime now = DateTime.now();
    gameInformation[indexKey] = {
      'Device Time': '${now.hour}:${now.minute}:${now.second}',
      'Dot Number': dot ?? -1,
      'Dot Position Center (X,Y)': dot != null ? '${dotPosition.dx}, ${dotPosition.dy}' : 'null',
      'Line Position (X,Y)': dot != null ? '${linePosition.dx}, ${linePosition.dy}' : 'null',
    };
    indexKey++;
  }

  bool isPointOnCircle(Offset center, Offset point, double radius) {
    return (center - point).distance <= radius;
  }

  Offset findIntersection(double x1, double y1, double x2, double y2) {
    final slope = (y2 - y1) / (x2 - x1 + 0.0001); // Avoid div by zero
    final x = x1 + (x2 - x1) * 0.5;
    final y = y1 + slope * (x - x1);
    return Offset(x, y);
  }

  void onUserDraw(Offset point, double circleRadius) {
    points.add(point);

    bool isOnAnyCircle = false;
    final dotMap = circlePositions[circlePositionKey]!;

    for (var entry in dotMap.entries) {
      final circleCenter = Offset(entry.value.dx * screenWidth, entry.value.dy * screenHeight);
      if (isPointOnCircle(circleCenter, point, circleRadius)) {
        if (lastEnteredCircle != entry.key) {
          final intersect = findIntersection(circleCenter.dx, circleCenter.dy, point.dx, point.dy);
          recordDotInteraction(entry.key, circleCenter, intersect);
          lastEnteredCircle = entry.key;
          isFirstTouch = false;
        }
        isOnAnyCircle = true;
        break;
      }
    }

    if (!isOnAnyCircle) {
      if (isFirstTouch) {
        recordDotInteraction(null, Offset.zero, Offset.zero);
        isFirstTouch = false;
      }
      lastEnteredCircle = null;
    }
  }

  Future<void> submitDrawing() async {
    await _captureScreenshot();
    await uploadDotDataToFirestore();
    await uploadScreenshotToFirebase();
  }

  Future<void> _captureScreenshot() async {
    capturedImageBytes = await screenshotController.capture();
  }

  Future<void> uploadDotDataToFirestore() async {
    for (final entry in gameInformation.entries) {
      final now = DateTime.now();
      final paddedKey = entry.key.toString().padLeft(2, '0');
      latestDocId = '${now.day}-${now.month}-${now.year} ${now.hour}:${now.minute}:${now.second} - $paddedKey';
      await FirebaseFirestore.instance
          .collection('Connect The Dots - 1007 - $patientEmail')
          .doc('$latestDocId - $patientId')
          .set(entry.value);
    }
  }

  Future<void> uploadScreenshotToFirebase() async {
    if (capturedImageBytes == null) return;

    final ref = firebase_storage.FirebaseStorage.instance
        .ref('Images')
        .child('Connect The Dots - 1007 - $patientEmail - ${DateTime.now().microsecondsSinceEpoch}.png');

    await ref.putData(capturedImageBytes!);
    final downloadURL = await ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('Connect The Dots - 1007 - $patientEmail - Image')
        .doc('$latestDocId - $patientId')
        .set({'Screenshot Url': downloadURL});
  }

  @override
  void onGameStart() {
    resetGame();
  }

  @override
  void onGameEnd() {
    // Optionally implement if needed
  }

  @override
  void onUserInteraction(dynamic _) {
    // Not needed for this game
  }

}
