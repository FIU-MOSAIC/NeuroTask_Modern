import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/game/base/game_controller.dart';
import 'dart:math';

class ConnectTheDotsController extends GameController implements Game {
  final Random _random = Random();
  final RxList<Offset> points = <Offset>[].obs;
  final RxBool isFirstTouch = true.obs;
  final Rxn<String> lastEnteredCircle = Rxn<String>();
  final RxInt circlePositionKey = 1.obs;
  final RxInt indexKey = 1.obs;

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

  final Map<int, Map<String, dynamic>> gameInformation = {};

  ConnectTheDotsController() {
    _generateRandomPosition();
  }

  @override
  String get title => 'Connect The Dots';

  @override
  String get info =>
      'Draw a line connecting the dots in increasing numerical order from 1-10. Tap Submit when done.';

  @override
  String get route => '/connect-dots';

  @override
  Icon get gameIcon => const Icon(Icons.gesture);

  void _generateRandomPosition() {
    circlePositionKey.value = _random.nextInt(3) + 1;
  }

  void reset() {
    points.clear();
    lastEnteredCircle.value = null;
    indexKey.value = 1;
    isFirstTouch.value = true;
    _generateRandomPosition();
  }

  @override
  void onGameStart() {
    reset();
  }

  @override
  void onGameEnd() {
    // Save game data or handle completion
    showCompletionDialog(
      title: 'Well done!',
      message: 'You completed Connect The Dots.',
    );
  }

  @override
  void onUserInteraction(dynamic data) {
    if (data is Offset) {
      _handleTouch(data);
    } else if (data == 'reset') {
      reset();
    } else if (data == 'submit') {
      endGame();
    }
  }

  void _handleTouch(Offset localPosition) {
    points.add(localPosition);

    double circleRadius = 50; // Set a sensible fixed radius or receive from UI

    bool isOnCircle = false;
    final circleMap = circlePositions[circlePositionKey.value]!;

    for (final entry in circleMap.entries) {
      final circleCenter = Offset(entry.value.dx * 300, entry.value.dy * 600); // Dummy size - replace by UI-provided
      if ((circleCenter - localPosition).distance <= circleRadius) {
        if (lastEnteredCircle.value != entry.key) {
          // Log interaction info here
          lastEnteredCircle.value = entry.key;
          isFirstTouch.value = false;
        }
        isOnCircle = true;
        break;
      }
    }
    if (!isOnCircle && isFirstTouch.value) {
      // Log first touch outside circles
      isFirstTouch.value = false;
    }
  }
}
