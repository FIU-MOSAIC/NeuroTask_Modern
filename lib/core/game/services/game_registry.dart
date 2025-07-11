import 'package:flutter/material.dart';
import 'game_info.dart';

class GameRegistry {
  static final List<GameInfo> _games = [
    const GameInfo(
      title: 'Memory Game',
      gameIcon: Icons.psychology,
      route: '/memory-game',
      description: 'Match the animal pairs to test your memory',
      isImplemented: true,
    ),
    const GameInfo(
      title: 'Grandfather Passage',
      gameIcon: Icons.book,
      route: '/grandfather',
      description: 'Reading comprehension test',
      isImplemented: false,
    ),
    const GameInfo(
      title: 'Target Game',
      gameIcon: Icons.track_changes,
      route: '/target-game',
      description: 'Reaction time and attention test',
      isImplemented: false,
    ),
    const GameInfo(
      title: 'Color Game',
      gameIcon: Icons.palette,
      route: '/color-game',
      description: 'Stroop test for cognitive flexibility',
      isImplemented: false,
    ),
    const GameInfo(
      title: 'Picture Test',
      gameIcon: Icons.image,
      route: '/picture-test',
      description: 'Visual recognition and naming',
      isImplemented: false,
    ),
    const GameInfo(
      title: 'Connect The Dots',
      gameIcon: Icons.gesture,
      route: '/connect-dots',
      description: 'Sequential processing and motor skills',
      isImplemented: false,
    ),
    const GameInfo(
      title: 'Visuospatial Test',
      gameIcon: Icons.grid_4x4,
      route: '/visuospatial-game',
      description: 'Spatial reasoning and pattern recognition',
      isImplemented: false,
    ),
    const GameInfo(
      title: 'Narration Reading',
      gameIcon: Icons.record_voice_over,
      route: '/narration-reading',
      description: 'Speech and reading assessment',
      isImplemented: false,
    ),
  ];

  static List<GameInfo> get allGames => _games;
  
  static List<GameInfo> get implementedGames => 
    _games.where((game) => game.isImplemented).toList();
  
  static List<GameInfo> get availableGames => 
    _games.where((game) => game.isImplemented).toList();
} 