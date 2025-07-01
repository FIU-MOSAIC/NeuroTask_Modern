import 'package:flutter/material.dart';
import 'package:neurotask_ng/pages/games/game.dart';

class GrandFather extends StatefulWidget {
  @override
  State<GrandFather> createState() => GrandfatherState();

  const GrandFather({super.key});
}

class GrandfatherState extends State<GrandFather> implements Game {
  @override
  String get title => "Grandfather Passage";
  @override
  String get info => "Read short passages";
  @override
  Icon get gameIcon => Icon(Icons.mic);

  bool isStart = false;

  final String grandfatherPassageText =
      "You wished to know all about my grandfather. Well, he is nearly ninety-three years old. He dresses himself in an ancient black frock coat, usually minus several buttons; yet he still thinks as swiftly as ever. A long, flowing beard clings to his chin, giving those who observe him a pronounced feeling of the utmost respect. When he speaks his voice is just a bit cracked and quivers a trifle. Twice each day he plays skillfully and with zest upon our small organ. Except in the winter when the ooze or snow or ice prevents, he slowly takes a short walk in the open air each day. We have often urged him to walk more and smoke less, but he always answers, “Banana Oil!” Grandfather likes to be modern in his language.";

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width; 
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => print("Back"),
            icon: const Icon(Icons.exit_to_app),
            tooltip: "Back to main menu",
          ),
          title: Text("GrandFather Passage"),
          actions: [
            IconButton(
              onPressed: () => print("Description"),
              icon: const Icon(Icons.description),
              tooltip: "Description of how to properly conduct test.",
            ),
            IconButton(
              onPressed: () => print("submit"),
              icon: const Icon(Icons.send),
              tooltip: "Submit recording",
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              Scrollbar(
                child: SizedBox(
                  width: width * .5,
                  child: Text(
                    grandfatherPassageText,
                    textScaler: TextScaler.linear(2.0),
                  ),
                ),
              ),
              // Text(
              //   grandfatherPassageText,
              //   textScaler: TextScaler.linear(2.0),),
              FloatingActionButton.extended(
                onPressed: () => print("Start Recording"),
                label: Text("Start Recording"),
                tooltip: "Start Recording",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
