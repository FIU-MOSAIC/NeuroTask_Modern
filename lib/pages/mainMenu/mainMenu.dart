import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Menu"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_sharp),
            tooltip: "Log out",
            onPressed: () => print("logging out"),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 3,
        children: List.generate(9, (index) {
          return Center(
            child: Container(
              height: screenHeight * .4,
              width: screenWidth * .4,
              child: FittedBox(
                child: FloatingActionButton.extended(
                  label: Text('$index'),
                  onPressed: () => print("OH GOD I'VE been PRESSED!"),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
