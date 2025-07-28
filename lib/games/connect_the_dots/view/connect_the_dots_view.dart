import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/game/widgets/game_view.dart';
import '../controller/connect_the_dots_controller.dart';

class ConnectTheDotsView extends StatefulWidget {
final controller = Get.put(ConnectTheDotsController());
  @override
 State<ConnectTheDotsView> createState() => _ConnectTheDotsViewState();
}

class _ConnectTheDotsViewState extends State<ConnectTheDotsView> {
 final controller = ConnectTheDotsController();
@override
Widget build(BuildContext context) {
  return GameView(
    controller: controller,
    title: controller.title,
    instructions: controller.info,
    child: Obx(() {
      if (!controller.isGameActive.value) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.title,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  controller.info,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: controller.startGame,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Start Game',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return _buildGameScreen(context);
      }
    }),
  );
}

Widget _buildGameScreen(BuildContext context) {
  final circleRadius = 30.0;
  final size = MediaQuery.of(context).size;




  final circles = controller.circlePositions[controller.circlePositionKey.value]!;




  return GestureDetector(
    onPanUpdate: (details) {
       if (controller.isGameActive.value) {
         controller.onUserInteraction(details.localPosition);
       }
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final localPosition = renderBox.globalToLocal(details.localPosition);
      controller.points.add(localPosition);

     setState(() {
     controller.points.add(localPosition);
 });
    },
    child: Stack(
      children: [
        CustomPaint(
          painter: _LinePainter(controller.points),
          size: Size(size.width, size.height),
        ),
        ...circles.entries.map((entry) {
          final center = Offset(entry.value.dx * size.width, entry.value.dy * size.height);
          return Positioned(
            left: center.dx - circleRadius,
            top: center.dy - circleRadius,
            child: Container(
              width: circleRadius * 2,
              height: circleRadius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
                color: Colors.transparent,
              ),
              alignment: Alignment.center,
              child: Text(entry.key,
                  style: TextStyle(
                    fontSize: circleRadius * 0.8,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          );
        }).toList(),
        Positioned(
          bottom: 20,
          right: 20,
          child: ElevatedButton(
            onPressed: () => controller.onUserInteraction('submit'),
            child: const Text('Submit'),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: ElevatedButton(
            onPressed: () => controller.onUserInteraction('reset'),
            child: const Text('Reset'),
          ),
        ),
      ],
    ),//
  );
}
}

class _LinePainter extends CustomPainter {
final List<Offset> points;
_LinePainter(this.points);

@override
void paint(Canvas canvas, Size size) {
  if (points.isEmpty) return;
  final paint = Paint()
    ..color = Colors.black
    ..strokeWidth = 3
    ..strokeCap = StrokeCap.round;
  for (var i = 0; i < points.length - 1; i++) {
    canvas.drawLine(points[i], points[i + 1], paint);
  }
}

@override
bool shouldRepaint(covariant _LinePainter oldDelegate) {
  return oldDelegate.points != points;
}
}
