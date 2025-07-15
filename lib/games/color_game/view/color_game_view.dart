import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/game/widgets/game_view.dart';
import '../controller/color_game_controller.dart';

class ColorGameView extends StatelessWidget {
  final controller = Get.put(ColorGameController());

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    // Initialization can be passed dynamically; here just a placeholder
    controller.initialize(
      id: "placeholder-id",
      email: "placeholder@email.com",
      height: screen.height,
      width: screen.width,
    );

    return GameView(
      controller: controller,
      title: controller.title,
      instructions: controller.info,
      child: Obx(() => controller.isGameActive.value
          ? _buildGameContent(context)
          : _buildStartScreen()),
    );
  }

  Widget _buildStartScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Color Game', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Text(
            'Speak the color you **see**, not the word you read!',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
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

  Widget _buildGameContent(BuildContext context) {
    return Stack(
      children: [
        Obx(() {
          final idx = controller.currentIndex.value;
          if (idx < 0 || idx >= controller.colorMap.length) return SizedBox.shrink();

          final word = controller.colorMap.keys.elementAt(idx);
          //final colorName = controller.textColors[idx];
          final color = controller.colorMap[word] ?? Colors.black;

          return Positioned(
            top: controller.positionY.value * controller.screenHeight,
            left: controller.positionX.value * controller.screenWidth,
            child: Text(
              word,
              style: TextStyle(
                color: color,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }),
        Align(
          alignment: Alignment.bottomCenter,
          child: Obx(() => Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "You said: ${controller.voiceToText.value}",
                  style: TextStyle(fontSize: 18),
                ),
              )),
        ),
      ],
    );
  }
}
