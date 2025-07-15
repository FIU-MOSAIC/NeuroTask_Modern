import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neurotask_ng/core/game/services/game_registry.dart';
import 'package:neurotask_ng/services/auth_service.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainMenuController());
    var games = GameRegistry.allGames;

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
      body: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, index) {
          return Container(
            height: 60,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: FloatingActionButton.extended(
              label: Text(games[index].title),
              icon: Icon(games[index].gameIcon),
              onPressed: () => Get.toNamed(games[index].route),
            ),
          );
        },
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