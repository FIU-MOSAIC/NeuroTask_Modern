import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:neurotask_ng/games/narration_reading_game/controllers/narration_game_controller.dart';
import 'package:get/get.dart';
import '../../../core/game/widgets/game_view.dart';

class NarrationReadingGameView extends StatelessWidget {
  NarrationReadingGameView({super.key});
  final controller = Get.put(NarrationGameController());

  @override
  Widget build(BuildContext context) {
    return GameView(
      controller: controller,
      title: 'Narration Game',
      instructions: 'Narrate a few short stories. Read them aloud.',
      child: Obx(
        () => controller.isGameActive.value
            ? _buildNarrationScreen()
            : _buildStartScreen(),
      ),
    );
  }

  Widget _buildStartScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Narration Reading Game',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text('Read the short passages!', style: TextStyle(fontSize: 18)),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => controller.startGame(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: Text('Start Game', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  Widget _buildNarrationScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SingleChildScrollView(
            child: Text(
              controller.sentences[controller.counter.toInt()],
              textScaler: TextScaler.linear(2),
            )
          )
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () => controller.onUserInteraction(Void),
              child: Text("Next"),
            )
          ],
        )
      ],
    );
  }
}
