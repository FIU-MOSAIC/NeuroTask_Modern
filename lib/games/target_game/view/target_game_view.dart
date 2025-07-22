import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/game/widgets/game_view.dart';
import '../controller/target_game_controller.dart';

class TargetGameView extends StatelessWidget {
  final controller = Get.put(TargetGameController());

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    controller.initialize(
      id: "patient001",
      email: "test@example.com",
      height: screenSize.height,
      width: screenSize.width,
    );

    return GameView(
      controller: controller,
      title: 'Target Game',
      instructions: 'Tap the target as quickly as possible when it appears.',
      child: Obx(() => controller.isGameActive.value
          ? _buildGameContent()
          : _buildStartScreen()),
    );
  }

  Widget _buildStartScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Target Game',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Text(
            'Tap the target as quickly as possible when it appears!',
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

  Widget _buildGameContent() {
    return Obx(() {
      return Stack(
        children: [
          if (controller.showTarget.value)
            Positioned(
              left: controller.targetX.value *
                  MediaQuery.of(Get.context!).size.width,
              top: controller.targetY.value *
                  MediaQuery.of(Get.context!).size.height,
              child: GestureDetector(
                onTap: controller.handleTap,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
