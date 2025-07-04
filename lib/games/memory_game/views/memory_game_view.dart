import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/game/widgets/game_view.dart';
import '../controllers/memory_game_controller.dart';
import '../models/card_model.dart';

class MemoryGameView extends StatelessWidget {
  final controller = Get.put(MemoryGameController()); // GetX controller instance

  @override
  Widget build(BuildContext context) {
    return GameView(
      controller: controller,
      title: 'Memory Game',
      instructions: 'Match all the animal pairs. Tap two cards to flip them. If they match, they stay revealed. Try to match all pairs with as few moves as possible!',
      child: Obx(() => controller.isGameActive.value
        ? _buildCardGrid()
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
            'Memory Game',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Match the animal pairs!',
            style: TextStyle(fontSize: 18),
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

  Widget _buildCardGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double spacing = 12;
        int crossAxisCount = 4;
        // childAspectRatio < 1 makes the cards taller than they are wide
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: 0.65, // Try 0.65 for a tall card look
          ),
          itemCount: controller.cards.length,
          itemBuilder: (context, index) {
            final card = controller.cards[index];
            return _buildCard(card);
          },
        );
      },
    );
  }

  Widget _buildCard(CardModel card) {
    return GestureDetector(
      onTap: () => controller.onUserInteraction(card),
      child: Obx(() => Card(
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            color: card.isMatched.value
              ? Colors.green.shade100 
              : card.isFlipped.value
                ? Colors.white 
                : Colors.blue.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: card.isFlipped.value || card.isMatched.value
              ? Text(
                  card.value,
                  style: TextStyle(fontSize: 32),
                )
              : SizedBox.shrink(),
          ),
        ),
      ),
    ));
  }
}