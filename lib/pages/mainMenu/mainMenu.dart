import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neurotask_ng/pages/games/grandfather_passage.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    var games = [GrandFather(),GrandFather(),GrandFather(),GrandFather(),GrandFather(),GrandFather()];

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
        children: List.generate(games.length, (index) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: SizedBox(
              height: screenHeight * .4,
              width: screenWidth * .4,
                child: FloatingActionButton.extended(
                  label: Text(games[index].title),
                  icon: games[index].gameIcon,
                  onPressed: () => Get.toNamed(games[index].route),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
