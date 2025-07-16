import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import '../../../core/game/widgets/game_view.dart';
import '../controller/connect_the_dots_controller.dart';

class ConnectTheDotsView extends StatelessWidget {
  const ConnectTheDotsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConnectTheDotsController>(
      init: ConnectTheDotsController(),
      builder: (controller) {
        return GameView(
          controller: controller,
          title: controller.title,   // <-- Add this line
          child: Obx(() {
            final dotMap = controller.circlePositions[controller.circlePositionKey]!;
            final circleDiameter = controller.screenWidth * 0.1;
            final circleRadius = circleDiameter / 2;

            return Screenshot(
              controller: controller.screenshotController,
              child: Stack(
                children: [
                  // Dots
                  for (MapEntry<String, Offset> entry in dotMap.entries)
                    Positioned(
                      left: entry.value.dx * controller.screenWidth - circleRadius,
                      top: entry.value.dy * controller.screenHeight - circleRadius,
                      child: Container(
                        width: circleDiameter,
                        height: circleDiameter,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black,
                            width: controller.screenWidth * 0.005,
                          ),
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          entry.key,
                          style: TextStyle(
                            fontSize: circleDiameter * 0.4,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                  // Drawing Area
                  GestureDetector(
                    onPanUpdate: (details) {
                      controller.onUserDraw(details.localPosition, circleRadius);
                    },
                    child: CustomPaint(
                      painter: _LinePainter(points: controller.points),
                      size: Size.infinite,
                    ),
                  ),

                  // Submit + Reset Buttons
                  Positioned(
                    bottom: controller.screenHeight * 0.03,
                    left: controller.screenWidth * 0.1,
                    right: controller.screenWidth * 0.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text("Reset"),
                          onPressed: controller.resetGame,
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.check),
                          label: const Text("Submit"),
                          onPressed: () async {
                            await controller.submitDrawing();
                            Get.snackbar("Submitted", "Your drawing and data have been saved.",
                              backgroundColor: Colors.green.shade100,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<Offset> points;

  _LinePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
