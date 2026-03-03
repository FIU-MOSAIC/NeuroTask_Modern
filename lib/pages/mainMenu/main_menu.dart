import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neurotask_ng/core/game/services/game_registry.dart';
import 'package:neurotask_ng/services/auth_service.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainMenuController());
    final games = GameRegistry.allGames;
    const pageColor = Color(0xFFEDEDF5);
    const cardColor = Color(0xFFC9D1EE);
    const primaryText = Color(0xFF0A2A66);

    return Scaffold(
      backgroundColor: pageColor,
      appBar: AppBar(
        backgroundColor: pageColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Main Menu',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w500,
            color: primaryText,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: IconButton(
              icon: const Icon(
                Icons.logout,
                size: 34,
                color: Color(0xFF4E596D),
              ),
              tooltip: 'Log out',
              onPressed: () => controller.logOut(),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
        child: GridView.builder(
          itemCount: games.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.6,
          ),
          itemBuilder: (context, index) {
            final game = games[index];
            return _MenuCard(
              title: game.title,
              icon: game.gameIcon,
              cardColor: cardColor,
              textColor: primaryText,
              onTap: () => Get.toNamed(game.route),
            );
          },
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.title,
    required this.icon,
    required this.cardColor,
    required this.textColor,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color cardColor;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x17000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(icon, size: 50, color: textColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.15,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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