import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/game/base/game_controller.dart';

class TargetGameController extends GameController implements Game {
  final RxDouble targetX = 0.0.obs;
  final RxDouble targetY = 0.0.obs;
  final RxBool showTarget = false.obs;

  late double screenWidth;
  late double screenHeight;

  DateTime? appearTime;
  late String patientId;
  late String patientEmail;

  int tapCount = 0;
  final random = Random();

  @override
  String get title => "Target Game";

  @override
  String get info => "Tap the target as quickly as you can within 30 seconds.";

  @override
  String get route => "/target-game";

  @override
  Icon get gameIcon => Icon(Icons.track_changes);

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
    tapCount = 0;
    timeElapsed.value = 0;
    showNextTarget();

    // Watch time and end game at 30 seconds
    ever(timeElapsed, (_) {
      if (timeElapsed.value >= 30) {
        endGame();
      }
    });
  }

  void showNextTarget() {
    targetX.value = random.nextDouble() * 0.7;
    targetY.value = random.nextDouble() * 0.7;
    showTarget.value = true;
    appearTime = DateTime.now();
  }

  void handleTap() {
    if (!showTarget.value || appearTime == null) return;

    final tapTime = DateTime.now();
    final reactionTime = tapTime.difference(appearTime!).inMilliseconds;

    FirebaseFirestore.instance
        .collection("Target Game - $patientEmail")
        .add({
      "Patient ID": patientId,
      "Target X": targetX.value * screenWidth,
      "Target Y": targetY.value * screenHeight,
      "Appear Time": DateFormat.Hms().format(appearTime!),
      "Tap Time": DateFormat.Hms().format(tapTime),
      "Reaction Time (ms)": reactionTime,
      "Timestamp": DateTime.now().toIso8601String(),
    });

    tapCount++;
    showTarget.value = false;

    Future.delayed(const Duration(milliseconds: 800), () {
      if (isGameActive.value) {
        showNextTarget();
      }
    });
  }

  @override
  void onGameEnd() {
    showTarget.value = false;

    showCompletionDialog(
      title: "Time's up!",
      message: "You tapped the target $tapCount times in 30 seconds!",
    );
  }

  @override
  void onUserInteraction(dynamic _) {}
}
