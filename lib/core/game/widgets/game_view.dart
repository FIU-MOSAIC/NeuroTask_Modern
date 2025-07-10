import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../base/game_controller.dart';
import '../base/game_state.dart';

class GameView extends StatelessWidget {
  final GameController controller;
  final String title;
  final Widget child;
  final String? instructions;

  const GameView({
    Key? key,
    required this.controller,
    required this.title,
    required this.child,
    this.instructions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldExit = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Are you sure you want to exit the game?'),
              content: const Text('Session will be lost.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
                ),
              ],
            ),
          );
          if (shouldExit == true) {
            controller.resetGame();
            Get.delete<GameController>();
            Navigator.of(context).pop(result);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            IconButton(
              icon: Obx(() => Icon(controller.gameState.value.isActive ? Icons.pause : Icons.play_arrow)),
              tooltip: controller.gameState.value.isActive ? 'Pause' : 'Resume',
              onPressed: () {
                if (controller.gameState.value.isActive) {
                  controller.pauseGame();
                } else {
                  controller.resumeGame();
                }
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header row: timer, score, (optional) instructions
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Time: ${controller.timeElapsed.value}s', style: TextStyle(fontSize: 16)),
                  Text('Score: ${controller.score.value}', style: TextStyle(fontSize: 16)),
                  if (instructions != null)
                    IconButton(
                      icon: Icon(Icons.info_outline),
                      tooltip: 'Instructions',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Instructions'),
                            content: Text(instructions!),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              )),
              const SizedBox(height: 16),
              // Main game content
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
} 