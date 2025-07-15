import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/game/base/game_controller.dart';

class GrandfatherPassageController extends GameController implements Game {
  final RxBool isRecording = false.obs;
  final RxBool hasSubmitted = false.obs;

  @override
  String get title => "Grandfather Passage";
  @override
  String get info => "Read the passage aloud and submit your recording.";
  @override
  String get route => "/grandfather";
  @override
  Icon get gameIcon => Icon(Icons.mic);

  @override
  void onGameStart() {
    isRecording.value = false;
    hasSubmitted.value = false;
  }

  @override
  void onGameEnd() {
    // Save results or analytics here if needed
  }

  @override
  void onUserInteraction(dynamic data) {
    if (data == 'startRecording') {
      isRecording.value = true;
    } else if (data == 'stopRecording') {
      isRecording.value = false;
    } else if (data == 'submit') {
      hasSubmitted.value = true;
      endGame();
      showCompletionDialog(
        title: 'Well done!',
        message: 'You have submitted your recording.',
      );
    }
  }

  void startRecording() => onUserInteraction('startRecording');
  void stopRecording() => onUserInteraction('stopRecording');
  void submit() => onUserInteraction('submit');
  
}