import 'package:flutter/material.dart';
import 'package:neurotask_ng/pages/games/game.dart';

class GrandFather extends StatefulWidget implements Game{
  @override
  State<GrandFather> createState() => GrandfatherState();

  @override
  String get title => "Grandfather Passage";
  @override
  String get info => "Read short passages";
  @override
  String get route => "/grandfather";
  @override
  Icon get gameIcon => Icon(Icons.mic);

  const GrandFather({super.key});
}

class GrandfatherState extends State<GrandFather> {
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
          title: Text("GrandFather Passage"),
          actions: [
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Card(
                      margin: EdgeInsets.all(width * .2),
                      child: Center(
                        child: Text("To conduct this test, please press the 'Start Recording' button and then read the passage. Once complete press the same button again, and lastly press the submit button at the top right.",
                        textAlign: TextAlign.center,
                        ),
                      ),
                    );
              }),
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
              SizedBox(
                width: width * .7,
                height: height * .8,
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Text(
                      grandfatherPassageText,
                      textScaler: TextScaler.linear(2.0),
                    ),
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
