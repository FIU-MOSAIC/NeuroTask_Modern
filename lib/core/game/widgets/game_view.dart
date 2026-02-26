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
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.close),
            tooltip: 'Exit',
            onPressed: () async {
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
                Navigator.of(context).pop();
              }
            },
          ),
          title: Center(
            child: Text(
              title,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Obx(() => Icon(controller.gameState.value.isActive ? Icons.pause : Icons.play_arrow)),
              tooltip: controller.gameState.value.isActive ? 'Pause' : 'Resume',
              onPressed: () async {
                if (controller.gameState.value.isActive) {
                  // Show pause menu dialog
                  final result = await showDialog<String>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Game Paused'),
                      content: const Text(
                        'What would you like to do?',
                        style: TextStyle(
                          fontSize: 18
                        ),
                        ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop('resume');
                          },
                          child: const Text('Resume'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop('restart');
                          },
                          child: const Text('Restart'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop('exit');
                          },
                          child: const Text('Exit'),
                        ),
                      ],
                    ),
                  );
                  if (result == 'resume') {
                    controller.resumeGame();
                  } else if (result == 'restart') {
                    controller.resetGame();
                  } else if (result == 'exit') {
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
                      Navigator.of(context).pop();
                    }
                  }
                } else {
                  controller.resumeGame();
                }
              },
            ),
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
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Main game content
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
} 