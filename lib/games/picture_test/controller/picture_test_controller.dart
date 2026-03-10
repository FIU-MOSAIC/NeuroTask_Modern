import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neurotask_ng/core/game/base/game_controller.dart';
import 'package:neurotask_ng/core/game/base/game_state.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

class PictureTestController extends GameController implements Game {
  PictureTestController({Random? random}) : _random = random ?? Random();

  final Random _random;
  final SpeechToText speechToText = SpeechToText();

  static const Map<String, String> emojiAnswers = {
    '🍎': 'apple',
    '🚗': 'car',
    '🐶': 'dog',
    '⭐': 'star',
  };

  final currentEmoji = ''.obs;
  final heardText = ''.obs;
  final statusMessage = 'Preparing microphone...'.obs;
  final speechStatus = ''.obs;
  final speechError = ''.obs;
  final isListening = false.obs;
  final isCompleted = false.obs;

  late List<String> _emojiSequence;
  int _currentIndex = 0;
  bool _speechReady = false;
  Timer? _advanceTimer;
  bool _isTransitioning = false;

  @override
  String get title => 'Picture Test';

  @override
  String get route => '/picture-test';

  @override
  String get info => 'Say the name of the image you see.';

  @override
  Icon get gameIcon => const Icon(Icons.image);

  @override
  void onInit() {
    super.onInit();
    _initializeAndStart();
  }

  Future<void> _initializeAndStart() async {
    _speechReady = await speechToText.initialize(
      onStatus: _handleSpeechStatus,
      onError: _handleSpeechError,
    );
    statusMessage.value = _speechReady
        ? 'Say the name of the image you see.'
        : 'Microphone unavailable.';
    startGame();
  }

  @override
  void onGameStart() {
    isCompleted.value = false;
    heardText.value = '';
    speechError.value = '';
    speechStatus.value = '';
    score.value = 0;
    _emojiSequence = emojiAnswers.keys.toList()..shuffle(_random);
    _currentIndex = 0;
    _showCurrentEmoji();
  }

  @override
  void onGameEnd() {
    _advanceTimer?.cancel();
    _stopListening();
    isCompleted.value = true;
    statusMessage.value = 'Complete';
  }

  @override
  void onGamePause() {
    _stopListening();
    if (!isCompleted.value) {
      statusMessage.value = 'Paused';
    }
  }

  @override
  void onGameResume() {
    if (isCompleted.value) {
      return;
    }
    statusMessage.value = 'Say the name of the image you see.';
    _startListening();
  }

  @override
  void onGameReset() {
    _advanceTimer?.cancel();
    _stopListening();
    currentEmoji.value = '';
    heardText.value = '';
    speechError.value = '';
    speechStatus.value = '';
    isCompleted.value = false;
    _isTransitioning = false;
    statusMessage.value = _speechReady
        ? 'Say the name of the image you see.'
        : 'Microphone unavailable.';
  }

  @override
  void onUserInteraction(dynamic _) {}

  Future<void> goToMainMenu() async {
    await _stopListening();
    resetGame();
    Get.offAllNamed('/home');
  }

  Future<void> goToNextPicture() async {
    if (isCompleted.value || _isTransitioning) {
      return;
    }

    _isTransitioning = true;
    statusMessage.value = 'Skipped to next picture';
    await _stopListening();
    _moveToNextPicture();
  }

  void _showCurrentEmoji() {
    _isTransitioning = false;
    currentEmoji.value = _emojiSequence[_currentIndex];
    heardText.value = '';
    speechError.value = '';
    statusMessage.value = _speechReady
        ? 'Say the name of the image you see.'
        : 'Microphone unavailable.';
    _startListening();
  }

  Future<void> _startListening() async {
    if (!_speechReady ||
        gameState.value != GameState.playing ||
        isCompleted.value) {
      return;
    }

    await _stopListening();
    await speechToText.listen(
      listenFor: const Duration(seconds: 20),
      pauseFor: const Duration(seconds: 4),
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.confirmation,
        partialResults: true,
        cancelOnError: false,
      ),
      onResult: (result) {
        heardText.value = result.recognizedWords;
        _checkAnswer(result.recognizedWords);
      },
    );
    isListening.value = speechToText.isListening;
  }

  Future<void> _stopListening() async {
    if (speechToText.isListening) {
      await speechToText.stop();
    }
    isListening.value = false;
  }

  Future<void> _checkAnswer(String spokenText) async {
    final expected = emojiAnswers[currentEmoji.value];
    final normalized = spokenText.trim().toLowerCase();
    if (expected == null ||
        normalized.isEmpty ||
        !normalized.contains(expected)) {
      statusMessage.value = 'Try again';
      return;
    }

    _isTransitioning = true;
    score.value++;
    statusMessage.value = 'Correct';
    await _stopListening();
    _moveToNextPicture();
  }

  @override
  void onClose() {
    _advanceTimer?.cancel();
    _stopListening();
    super.onClose();
  }

  void _handleSpeechStatus(String status) {
    speechStatus.value = status;
    isListening.value = speechToText.isListening;

    if (status == 'listening') {
      statusMessage.value = 'Listening...';
      return;
    }

    if (_shouldRestartListening(status)) {
      statusMessage.value = 'Listening timed out. Try again.';
      _restartListeningSoon();
    }
  }

  void _handleSpeechError(SpeechRecognitionError error) {
    speechError.value = error.errorMsg;
    isListening.value = false;
    statusMessage.value = 'Speech error: ${error.errorMsg}';

    if (!error.permanent && _canListen) {
      _restartListeningSoon();
    }
  }

  bool _shouldRestartListening(String status) {
    return _canListen &&
        !_isTransitioning &&
        (status == 'done' || status == 'notListening') &&
        !speechToText.isListening;
  }

  bool get _canListen =>
      _speechReady &&
      !isCompleted.value &&
      gameState.value == GameState.playing &&
      currentEmoji.value.isNotEmpty;

  void _restartListeningSoon() {
    _advanceTimer?.cancel();
    _advanceTimer = Timer(const Duration(milliseconds: 500), () {
      if (_canListen && !speechToText.isListening) {
        _startListening();
      }
    });
  }

  void _moveToNextPicture() {
    if (_currentIndex >= _emojiSequence.length - 1) {
      endGame();
      return;
    }

    _currentIndex++;
    _advanceTimer?.cancel();
    _advanceTimer = Timer(const Duration(milliseconds: 700), _showCurrentEmoji);
  }
}
