import 'package:get/get.dart';

// Base controller for games
// Handles common game state and lifecycle management
abstract class GameController extends GetxController {
  // Reactive variables to track game state. Notifies views when these values change.
  // GetX state management library, replaces the need for stateful widgets and setState()
  final RxBool isGameActive = false.obs;
  final RxInt score = 0.obs;
  final RxInt timeElapsed = 0.obs;

// Template method pattern. Define the skeleton of the algorithm, but let subclasses override specific steps.
// Called to start the game
// Public method is called to start the game
void startGame() {
  isGameActive.value = true;
  onGameStart();
  // Optionally: start timer logic here
}

// Called to end the game
// Public method is called to end the game
void endGame() {
  isGameActive.value = false;
  onGameEnd();
  // Optionally: stop timer and save results here
}

// Called when the game starts
// Abstract method to be implemented by the subclass, allows each game to have its own start logic
void onGameStart();

// Called when the game ends
// Abstract method to be implemented by the subclass, allows each game to have its own end logic
void onGameEnd();

// Called when the user interacts with the game
void onUserInteraction(dynamic data);
}