import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neurotask_ng/pages/mainMenu/layout.dart';
import 'package:neurotask_ng/services/auth_service.dart';

class MainMenu extends StatelessWidget {

  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(MainMenuController());

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
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 15.0, horizontal: 30.0),
        child: Center(
          child: Layout()
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