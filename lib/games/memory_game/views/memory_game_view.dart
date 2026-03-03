import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
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
        double spacing = 6;
        int crossAxisCount = 2;
        // childAspectRatio < 1 makes the cards taller than they are wide
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: 1.1, // Try 0.65 for a tall card look
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
      child: Obx(()  {
        return _FlipContainer(
          isFlipped: card.isFlipped.value || card.isMatched.value,
          child: Card(
            elevation: 4,
            child: Container(
              decoration: BoxDecoration(
                color: card.isMatched.value
                  ? Colors.green.shade300 
                  : card.isFlipped.value
                      ? Colors.red.shade300
                      : Colors.blue.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: card.isFlipped.value || card.isMatched.value
                ? Text(
                    card.value,
                    style: TextStyle(fontSize: 64), //emoji size
                  )
                : SizedBox.shrink(),
              ),
            ),
          ),
        );
      }),
    );
  }
}

//this widget add a smooth flip of the card
  class _FlipContainer extends StatefulWidget {
    final Widget child;
    final bool isFlipped;

    const _FlipContainer({required this.child, required this.isFlipped});

    @override
    State<_FlipContainer> createState() => _FlipContainerState();
  }

  class _FlipContainerState extends State<_FlipContainer>
      with SingleTickerProviderStateMixin {
        late AnimationController _controller;

        @override 
        void initState(){
          super.initState();
          _controller = AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 400),
          );
          if (widget.isFlipped) _controller.value = 1;
        }

        @override
        void didUpdateWidget(covariant _FlipContainer oldWidget) {
          super.didUpdateWidget(oldWidget);
          if (widget.isFlipped != oldWidget.isFlipped) {
            if (widget.isFlipped) {
              _controller.forward();
          } else {
            _controller.reverse();
      }
    }
  }


        @override
        void dispose() {
          _controller.dispose();
          super.dispose();
        }

        @override
        Widget build(BuildContext context) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (_, child){
              double angle = _controller.value * pi;
              if (angle > pi /2) angle = angle - pi;

              return Transform (
                alignment: Alignment.center,
                transform: Matrix4.rotationY(angle),
                child: child,
              );
            },
            child: widget.child,
          );
        }
      }