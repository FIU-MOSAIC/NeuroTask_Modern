import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/game/base/game_controller.dart';
import '../models/card_model.dart';


class MemoryGameController extends GameController implements Game{
  final RxList<CardModel> cards = <CardModel>[].obs;
  final RxList<CardModel> flippedCards = <CardModel>[].obs;
  final RxBool canFlip = true.obs;
  final RxInt moves = 0.obs;
  final RxInt pairsFound = 0.obs;

  @override
  String get title => "Memory Game";
  @override
  String get info => "Match all the animal pairs. Tap two cards to flip them. If they match, they stay revealed. Try to match all pairs with as few moves as possible!";
  @override
  String get route => "/memory-game";
  @override
  Icon get gameIcon => Icon(Icons.memory);

  // Card values for the memory game
  final List<String> cardValues = ['🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼'];

  @override
  void onGameStart() {
    _initializeGame();
  }

  @override
  void onGameEnd() {
    // Game completed - could save results to Firebase here
    print('Game completed! Moves: ${moves.value}');
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
    showCompletionDialog(
      title: 'Congratulations!',
      message: 'You matched all the pairs in ${moves.value} moves.',
    );
  }


  // Method to start a new game
  void startNewGame() {
    // Reset game state to show start screen
    isGameActive.value = false; 
    
    // Clear all cards and reset game state
    cards.clear();
    flippedCards.clear();
    moves.value = 0;
    pairsFound.value = 0;
    canFlip.value = true;
  }
}