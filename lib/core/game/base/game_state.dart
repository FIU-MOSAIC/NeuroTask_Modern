enum GameState {
  initial,      // Game hasn't started yet
  instructions, // Showing instructions
  playing,      // Game is active
  paused,       // Game is paused
  completed,    // Game finished successfully
  failed,       // Game failed/abandoned
}

extension GameStateExtension on GameState {
  bool get isActive => this == GameState.playing;
  bool get isCompleted => this == GameState.completed || this == GameState.failed;
  bool get canPause => this == GameState.playing;
  bool get canResume => this == GameState.paused;
}