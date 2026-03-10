import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neurotask_ng/core/game/widgets/game_view.dart';
import 'package:neurotask_ng/games/picture_test/controller/picture_test_controller.dart';

class PictureTestScreen extends StatelessWidget {
  PictureTestScreen({super.key});

  final PictureTestController controller = Get.put(PictureTestController());

  @override
  Widget build(BuildContext context) {
    return GameView(
      controller: controller,
      title: 'Picture Test',
      instructions: 'Say the name of the image you see.',
      child: SafeArea(
        child: Obx(() {
          if (controller.isCompleted.value) {
            return _buildCompletedState();
          }
          return _buildListeningState();
        }),
      ),
    );
  }

  Widget _buildListeningState() {
    return Column(
      children: [
        const SizedBox(height: 24),
        const Text(
          'Say the name of the image you see.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        Text(
          controller.statusMessage.value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: controller.statusMessage.value == 'Correct'
                ? Colors.green.shade700
                : Colors.black87,
          ),
        ),
        const Spacer(),
        Text(
          controller.currentEmoji.value,
          style: const TextStyle(fontSize: 120),
        ),
        const SizedBox(height: 24),
        Text(
          controller.isListening.value ? 'Listening...' : 'Not listening',
          style: TextStyle(
            fontSize: 16,
            color: controller.isListening.value ? Colors.blue : Colors.grey,
          ),
        ),
        const SizedBox(height: 12),
        if (controller.speechStatus.value.isNotEmpty)
          Text(
            'Speech status: ${controller.speechStatus.value}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        if (controller.speechError.value.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'Speech error: ${controller.speechError.value}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.red),
          ),
        ],
        const SizedBox(height: 12),
        Text(
          controller.heardText.value.isEmpty
              ? 'Waiting for your answer'
              : 'You said: ${controller.heardText.value}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.goToNextPicture,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Next Picture',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Complete',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'You named all ${PictureTestController.emojiAnswers.length} images.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.goToMainMenu,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Back to Main Menu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
