import 'package:get/get.dart';
import '../../../core/game/base/game_controller.dart';
import '../models/card_model.dart';

class MemoryGameController extends GameController {
  final RxList<CardModel> cards = <CardModel>[].obs;
  final RxList<CardModel> flippedCards = <CardModel>[].obs;
  final RxBool canFlip = true.obs;
  final RxInt moves = 0.obs;
  final RxInt pairsFound = 0.obs;

  // Card values for the memory game
  final List<String> cardValues = ['🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼'];

  @override
  void onGameStart() {
    _initializeGame();
  }

  @override
  void onGameEnd() {
    // Game completed - could save results to Firebase here
    print('Game completed! Score: ${score.value}, Moves: ${moves.value}');
  }

  @override
  void onUserInteraction(dynamic data) {
    if (data is CardModel) {
      _handleCardTap(data);
    }
  }

  void _initializeGame() {
    // Create pairs of cards
    List<CardModel> cardPairs = [];
    for (int i = 0; i < cardValues.length; i++) {
      // Add two cards with the same value
      cardPairs.add(CardModel(id: i * 2, value: cardValues[i]));
      cardPairs.add(CardModel(id: i * 2 + 1, value: cardValues[i]));
    }
    
    // Shuffle the cards
    cardPairs.shuffle();
    
    cards.value = cardPairs;
    flippedCards.clear();
    score.value = 0;
    moves.value = 0;
    pairsFound.value = 0;
    canFlip.value = true;
  }

  void _handleCardTap(CardModel card) {
    if (!canFlip.value || card.isMatched.value || card.isFlipped.value) {
      return;
    }

    // Flip the card
    card.flip();
    flippedCards.add(card);

    // Check if we have two cards flipped
    if (flippedCards.length == 2) {
      canFlip.value = false;
      moves.value++;
      
      // Check for match
      if (flippedCards[0].value == flippedCards[1].value) {
        // Match found!
        flippedCards[0].markAsMatched();
        flippedCards[1].markAsMatched();
        score.value += 10;
        pairsFound.value++;
        
        // Check if game is complete
        if (pairsFound.value == cardValues.length) {
          _endGame();
        } else {
          flippedCards.clear();
          canFlip.value = true;
        }
      } else {
        // No match - flip cards back after delay
        Future.delayed(Duration(milliseconds: 1000), () {
          flippedCards.forEach((card) => card.flip());
          flippedCards.clear();
          canFlip.value = true;
        });
      }
    }
  }

  void _endGame() {
    onGameEnd();
    // Could show a completion dialog here
  }

  // Method to start a new game
  void startNewGame() {
    startGame();
  }
}