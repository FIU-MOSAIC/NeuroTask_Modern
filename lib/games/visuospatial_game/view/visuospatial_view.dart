import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neurotask_ng/core/game/widgets/game_view.dart';
import 'package:neurotask_ng/games/visuospatial_game/controller/visuospatial_controller.dart';
import 'package:neurotask_ng/games/visuospatial_game/model/shape_model.dart';

class VisuospatialGameView extends StatelessWidget {
  VisuospatialGameView({super.key});

  final controller = Get.put(VisuospatialController());

  @override
  Widget build(BuildContext context) {
    return GameView(
      controller: controller,
      title: 'Visuospatial Game',
      instructions: 'Draw a line connecting the shapes in order from 1 to 10.',
      child: Obx(() => controller.isGameActive.value
          ? _buildGameBoard(context)
          : _buildStartScreen()),
    );
  }

  Widget _buildStartScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Visuospatial Game',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Text('Connect the shapes in order from 1 to 10!',
              style: TextStyle(fontSize: 18)),
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

  Widget _buildGameBoard(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onPanUpdate: (details) {
            // Get the position relative to the Stack widget specifically
            final RenderBox? box = context.findRenderObject() as RenderBox?;
            if (box != null && !controller.hasBeenPenalized.value) {
              final localPosition = box.globalToLocal(details.globalPosition);
              controller.onUserDraw(localPosition);
            }
          },
          onPanEnd: (_) => controller.clearDrawing(),
          child: Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Obx(() => Stack(
        children: [
          // User's current drawing path
          CustomPaint(
            size: Size.infinite,
            painter: _DragLinePainter(controller.drawnPoints),
          ),

          // Connected lines between correct shapes
          CustomPaint(
            size: Size.infinite,
            painter: _ConnectionLinePainter(controller.shapes),
          ),

          // Shapes
          ...controller.shapes.map((shape) {
            return Positioned(
              left: shape.position.dx,
              top: shape.position.dy,
              child: Container(
                width: 60,
                height: 60,
                child: CustomPaint(
                  painter: _ShapePainter(
                    shape.type,
                    _getShapeColor(shape),
                  ),
                  child: Center(
                    child: Text(
                      '${shape.number}',
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),

          // Current target display
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Next: ${controller.currentTarget.value}',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
        )),
        ),
        );
      },
    );
  }

  Color _getShapeColor(ShapeModel shape) {
    if (shape.isConnected.value) {
      return Colors.green; // Successfully connected
    } else {
      return Colors.blue; // Default
    }
  }
}

class _ShapePainter extends CustomPainter {
  final ShapeType type;
  final Color color;

  _ShapePainter(this.type, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    // Add border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2; // Account for border
    final sides = _getSides(type);

    if (sides == 0) {
      canvas.drawCircle(center, radius, paint);
      canvas.drawCircle(center, radius, borderPaint);
      return;
    }

    final path = Path();
    for (int i = 0; i <= sides; i++) {
      final angle = (2 * pi / sides) * i - pi / 2;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  int _getSides(ShapeType type) {
    switch (type) {
      case ShapeType.triangle:
        return 3;
      case ShapeType.square:
        return 4;
      case ShapeType.pentagon:
        return 5;
      case ShapeType.hexagon:
        return 6;
      case ShapeType.heptagon:
        return 7;
      case ShapeType.octagon:
        return 8;
      case ShapeType.nonagon:
        return 9;
      case ShapeType.decagon:
        return 10;
      case ShapeType.circle:
        return 0;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _ConnectionLinePainter extends CustomPainter {
  final List<ShapeModel> shapes;

  _ConnectionLinePainter(this.shapes);

  @override
  void paint(Canvas canvas, Size size) {
    final connectedShapes = shapes.where((s) => s.isConnected.value).toList();
    connectedShapes.sort((a, b) => a.number.compareTo(b.number));
    
    if (connectedShapes.length < 2) return;

    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    // Draw lines between consecutive connected shapes
    for (int i = 0; i < connectedShapes.length - 1; i++) {
      final startShape = connectedShapes[i];
      final endShape = connectedShapes[i + 1];
      
      // Make sure they are actually consecutive numbers
      if (endShape.number == startShape.number + 1) {
        final start = startShape.position + Offset(30, 30);
        final end = endShape.position + Offset(30, 30);
        canvas.drawLine(start, end, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _DragLinePainter extends CustomPainter {
  final List<Offset> points;

  _DragLinePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = Colors.red.withOpacity(0.7)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}