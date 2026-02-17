import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/game/widgets/game_view.dart';
import '../controllers/grandfather_passage_controller.dart';

class GrandfatherPassageView extends StatelessWidget {
  final controller = Get.put(GrandfatherPassageController());

  final String passageText =
      "You wished to know all about my grandfather. Well, he is nearly ninety-three years old. He dresses himself in an ancient black frock coat, usually minus several buttons; yet he still thinks as swiftly as ever. A long, flowing beard clings to his chin, giving those who observe him a pronounced feeling of the utmost respect. When he speaks his voice is just a bit cracked and quivers a trifle. Twice each day he plays skillfully and with zest upon our small organ. Except in the winter when the ooze or snow or ice prevents, he slowly takes a short walk in the open air each day. We have often urged him to walk more and smoke less, but he always answers, “Banana Oil!” Grandfather likes to be modern in his language.";

  @override
  Widget build(BuildContext context) {
    return GameView(
      controller: controller,
      title: 'Grandfather Passage',
      instructions: 'Read the passage aloud. Press Start Recording, read the passage, then press Stop Recording. When finished, press Submit.',
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
          Text(
            'Grandfather Passage',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Read the passage aloud and submit your recording!',
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
            child: Text('Start', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  Widget _buildGameContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                passageText,
                textScaler: TextScaler.linear(2.0),
              ),
            ),
          ),
          SizedBox(height: 24),
          Obx(() => FloatingActionButton.extended(
                onPressed: () {
                  if (!controller.isRecording.value) {
                    controller.startRecording();
                  } else {
                    controller.stopRecording();
                  }
                },
                label: Text(controller.isRecording.value ? 'Stop Recording' : 'Start Recording'),
                backgroundColor: controller.isRecording.value ? Colors.red : Colors.blueAccent,
                tooltip: controller.isRecording.value ? 'Stop Recording' : 'Start Recording',
              )),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: controller.isRecording.value ? null : controller.submit,
            icon: Icon(Icons.send),
            label: Text('Complete Recording'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
