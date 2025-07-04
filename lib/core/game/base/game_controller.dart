import 'package:get/get.dart';
import 'game_state.dart';
import 'dart:async';
import 'package:flutter/material.dart';

abstract class Game{ //for each game, we need to define a title, route, info, and gameIcon
  String get title;
  String get route;
  String get info;//for tooltip of each game's button
  Icon get gameIcon; 
}

// Base controller for games
// Handles common game state and lifecycle management
abstract class GameController extends GetxController {
  // Reactive variables to track game state. Notifies views when these values change.
  // GetX state management library, replaces the need for stateful widgets and setState()
  final RxBool isGameActive = false.obs;
  final RxInt score = 0.obs;
  final RxInt timeElapsed = 0.obs;
  final Rx<GameState> gameState = GameState.initial.obs;
  
  // Timer for tracking game duration
  Timer? _gameTimer;
  DateTime? _gameStartTime;

  // Template method pattern. Define the skeleton of the algorithm, but let subclasses override specific steps.
  // Called to start the game
  // Public method is called to start the game
  void startGame() {
    _gameStartTime = DateTime.now();
    isGameActive.value = true;
    gameState.value = GameState.playing;
    _startTimer();
    onGameStart();
  }

  // Called to end the game
  // Public method is called to end the game
  void endGame() {
    isGameActive.value = false;
    gameState.value = GameState.completed;
    _stopTimer();
    _calculateFinalTime();
    onGameEnd();
  }

  // Pause the game
  void pauseGame() {
    if (gameState.value.canPause) {
      gameState.value = GameState.paused;
      _stopTimer();
      onGamePause();
    }
  }

  // Resume the game
  void resumeGame() {
    if (gameState.value.canResume) {
      gameState.value = GameState.playing;
      _startTimer();
      onGameResume();
    }
  }

  // Reset the game to initial state
  void resetGame() {
    _stopTimer();
    isGameActive.value = false;
    score.value = 0;
    timeElapsed.value = 0;
    gameState.value = GameState.initial;
    _gameStartTime = null;
    onGameReset();
  }

  // Called when the game starts
  // Abstract method to be implemented by the subclass, allows each game to have its own start logic
  void onGameStart();

  // Called when the game ends
  // Abstract method to be implemented by the subclass, allows each game to have its own end logic
  void onGameEnd();

  // Called when the game is paused
  void onGamePause() {}

  // Called when the game is resumed
  void onGameResume() {}

  // Called when the game is reset
  void onGameReset() {}

  // Called when the user interacts with the game
  void onUserInteraction(dynamic data);

  // Start the game timer
  void _startTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (gameState.value == GameState.playing) {
        timeElapsed.value++;
      }
    });
  }

  // Stop the game timer
  void _stopTimer() {
    _gameTimer?.cancel();
    _gameTimer = null;
  }

  // Calculate final game time
  void _calculateFinalTime() {
    if (_gameStartTime != null) {
      final endTime = DateTime.now();
      final duration = endTime.difference(_gameStartTime!);
      timeElapsed.value = duration.inSeconds;
    }
  }

  // Get game statistics for analytics
  Map<String, dynamic> getGameStats() {
    return {
      'score': score.value,
      'timeElapsed': timeElapsed.value,
      'gameState': gameState.value.toString(),
      'completedAt': DateTime.now().toIso8601String(),
    };
  }

  @override
  void onClose() {
    _stopTimer();
    super.onClose();
  }
}