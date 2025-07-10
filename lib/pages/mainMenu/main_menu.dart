import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neurotask_ng/games/grandfather_passage/views/grandfather_passage_view.dart';
import 'package:neurotask_ng/games/memory_game/controllers/memory_game_controller.dart';
import 'package:neurotask_ng/services/auth_service.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainMenuController());
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    final games = [
      {
        'title': 'Grandfather Passage',
        'icon': Icon(Icons.mic),
        'onPressed': () => Get.toNamed('/grandfather'),
      },
      {
        'title': 'Memory Game',
        'icon': Icon(Icons.memory),
        'onPressed': () => Get.toNamed('/memory-game'),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Menu"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_sharp),
            tooltip: "Log out",
            onPressed: () => controller.logOut(),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 3,
        children: List.generate(games.length, (index) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: SizedBox(
                height: screenHeight * .4,
                width: screenWidth * .4,
                child: FloatingActionButton.extended(
                  label: Text(games[index]['title'] as String),
                  icon: games[index]['icon'] as Icon,
                  onPressed: games[index]['onPressed'] as void Function(),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class MainMenuController extends GetxController {
  final _authService = AuthService();

  Future<void> logOut() async {
    await _authService.logOut();
    Get.offAllNamed('/login');
  }
}
