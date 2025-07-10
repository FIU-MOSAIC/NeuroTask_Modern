import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neurotask_ng/core/game/base/game_controller.dart';
import 'package:neurotask_ng/games/visuospatial_game/model/shape_model.dart';

class VisuospatialController extends GameController {
  final RxList<ShapeModel> shapes = <ShapeModel>[].obs;
  final RxInt currentTarget = 1.obs;
  List<Offset> locations = [];
  final RxBool hasBeenPenalized = false.obs;

  // Stores user-drawn path
  final RxList<Offset> drawnPoints = <Offset>[].obs;

  @override
  void onGameStart() {
    _initializeShapes();
  }

  @override
  void onGameEnd() {
    print("Visuospatial Game complete! Final Score: ${score.value}");
    locations.clear();
  }

  @override
  void onUserInteraction(dynamic data) {
    // Not used in drawing mode
  }

  Offset _findValidPosition(Random rand) {
    const double minDistance = 80.0; // Minimum distance between shape centers
    const int maxAttempts = 100; // Prevent infinite loops
    int attempts = 0;

    while (attempts < maxAttempts) {
      attempts++;
      
      // Generate a random position
      Offset position = Offset(
        60.0 + rand.nextDouble() * 250,
        100.0 + rand.nextDouble() * 400,
      );

      // Check if this position is too close to any existing shape
      bool tooClose = false;
      for (Offset prevPosition in locations) {
        // Calculate actual distance between centers (both X and Y)
        double distance = (position - prevPosition).distance;
        if (distance < minDistance) {
          tooClose = true;
          break;
        }
      }

      // If position is valid, return it
      if (!tooClose) {
        return position;
      }
    }

    // Fallback: if we can't find a valid position after max attempts,
    // return a position anyway to avoid infinite loops
    return Offset(
      60.0 + rand.nextDouble() * 250,
      100.0 + rand.nextDouble() * 400,
    );
  }

  void _initializeShapes() {
    final rand = Random();
    final shapeTypes = ShapeType.values;
    
    // Clear previous locations
    locations.clear();

    shapes.value = List.generate(10, (i) {
      Offset position = _findValidPosition(rand);
      
      // Add this position to the locations list
      locations.add(position);
      
      return ShapeModel(
        number: i + 1,
        type: shapeTypes[rand.nextInt(shapeTypes.length)],
        position: position,
      );
    });

    currentTarget.value = 1;
    score.value = 0;
    drawnPoints.clear();
  }

  /// Called continuously while user draws
  void onUserDraw(Offset position) {
    drawnPoints.add(position);

    // Check if we're over any shape
    for (final shape in shapes) {
      if (_isInsideShape(shape, position)) {
        // Only allow connecting if this shape is the correct next one
        if (shape.number == currentTarget.value && !shape.isConnected.value) {
          shape.isConnected.value = true;
          score.value += 10;

          if (currentTarget.value == 10) {
            endGame();
          } else {
            currentTarget.value++;
          }
          
          // Clear the drawing path when a successful connection is made
          drawnPoints.clear();
        }
        else if (!shape.isConnected.value) {

          if (!hasBeenPenalized.value) {
            score.value -= 10;
            hasBeenPenalized.value = true;
          }

          drawnPoints.clear();
        }

        break;
      } 
    }
  }

  bool _isInsideShape(ShapeModel shape, Offset point, {double radius = 30}) {
    // Calculate the center of the shape (since shapes are 60x60)
    final shapeCenter = shape.position + Offset(30, 30);
    return (shapeCenter - point).distance <= radius;
  }
  /// Clears the drawing when user lifts finger
  void clearDrawing() {
    hasBeenPenalized.value = false;
    drawnPoints.clear();
  }

}
