import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../../core/game/base/game_controller.dart';
import '../../../core/game/base/game_state.dart';

class ColorGameController extends GameController implements Game {
  final speechToText = SpeechToText();
  final voiceToText = "Skipped".obs;

  final currentIndex = (-1).obs;
  final positionX = 0.0.obs;
  final positionY = 0.0.obs;

  late double screenHeight;
  late double screenWidth;

  final random = Random();

  int index = 0;
  int intervalTime = 3;

  DateTime? deviceTime;
  DateTime? disapearTime;

  late String patientId;
  late String patientEmail;

  final colorMap = {
    "Red": Colors.yellow,
    "Green": Colors.blue,
    "Blue": Colors.brown,
    "Yellow": Colors.green,
    "Orange": Colors.red,
    "Pink": Colors.orange,
    "Purple": Colors.purple,
    "Brown": Colors.black,
    "Black": Colors.pink,
  };

  final textColors = [
    "Yellow", "Blue", "Brown", "Green", "Red",
    "Orange", "Purple", "Black", "Pink", "Yellow"
  ];

  @override
  String get title => "Color Game";

  @override
  String get info => "Speak the color you see, not the word you read.";

  @override
  String get route => "/color-game";

  @override
  Icon get gameIcon => Icon(Icons.palette);

  @override
  void onInit() {
    super.onInit();
    speechToText.initialize(); // Pre-initialize
  }

  Future<void> initialize({
    required String id,
    required String email,
    required double height,
    required double width,
  }) async {
    patientId = id;
    patientEmail = email;
    screenHeight = height;
    screenWidth = width;
  }

  @override
  void onGameStart() {
    index = 0;
    voiceToText.value = "Skipped";
    getRandomPosition();
    deviceTime = DateTime.now();
    currentIndex.value = index;
    startListening();
  }

  @override
  void onGameEnd() {
    stopListening();
    currentIndex.value = -1;

    showCompletionDialog(
      title: "Good job!",
      message: "You finished the Color Game.",
    );
  }

  @override
  void onUserInteraction(dynamic _) {}

  void handleTick() {
    if (isGameActive.value && gameState.value == GameState.playing) {
      if (timeElapsed.value % intervalTime == 0 && timeElapsed.value != 0) {
        recordData();
      }
    }
  }

  void getRandomPosition() {
    positionX.value = random.nextDouble() * 0.7;
    positionY.value = 0.1 + random.nextDouble() * 0.7;
  }

  void recordData() {
    disapearTime = DateTime.now();
    stopListening();

    if (index < colorMap.length) {
      final key = colorMap.keys.elementAt(index);
      final value = textColors[index];

      final success = voiceToText.value.toLowerCase().contains(key.toLowerCase()) ? 1 : 0;
      final appearTime = DateFormat('HH:mm:ss').format(deviceTime!);
      final disappearTime = DateFormat('HH:mm:ss').format(disapearTime!);
      final timestamp = DateTime.now().toIso8601String();

      FirebaseFirestore.instance
          .collection("Color Game - 1005 - $patientEmail")
          .doc("$timestamp - $patientId")
          .set({
        'Patient Id': patientId,
        'Device Time': appearTime,
        'Text Appear Time': appearTime,
        'Text Disappear Time': disappearTime,
        'Text appear Location (x,y)': '${positionX.value * screenWidth}, ${positionY.value * screenHeight}',
        'Text Content': key,
        'Text Color': value,
        'Text from voice to text': voiceToText.value,
        'Text_Change_Duration': intervalTime,
        'Success': success,
      });

      index++;
      if (index < colorMap.length) {
        Future.delayed(const Duration(milliseconds: 500), () {
          voiceToText.value = "Skipped";
          currentIndex.value = index;
          getRandomPosition();
          deviceTime = DateTime.now();
          startListening();
        });
      } else {
        endGame();
      }
    }
  }

  Future<void> startListening() async {
    // Comment out for testing
    // await speechToText.listen(onResult: (result) {
    //   voiceToText.value = result.recognizedWords;
    // });
    voiceToText.value = "Testing"; // Mock response
  }

  Future<void> stopListening() async {
    await speechToText.stop();
  }

  @override
  void onReady() {
    ever(timeElapsed, (_) => handleTick());
    super.onReady();
  }

  @override
  void onClose() {
    stopListening();
    super.onClose();
  }
}
