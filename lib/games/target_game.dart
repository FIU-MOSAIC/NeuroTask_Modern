import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neurotask_ng/constant/responsive.dart';
import 'package:neurotask_ng/pages/homepage.dart';
import 'package:neurotask_ng/services/target_game_services.dart';
import 'package:neurotask_ng/ui/message/start_message.dart';

class TargetGame extends StatefulWidget {
  const TargetGame({super.key});

  @override
  State<TargetGame> createState() => _TargetGameState();
}

class _TargetGameState extends State<TargetGame> {
  bool _isDialogVisible = false;
  int score = 0;
  double positionX = 0.0;
  double positionY = 0.0;
  Random random = Random();
  int index = 0;
  Map<double,double> circleSize = {
    0.1 : 0.05,
    0.09 : 0.045,
    0.095 : 0.0475,
    0.08 : 0.04,
  };
  void getRandomPosition(){
    index = random.nextInt(4);
    //debugPrint('index: $index');
    positionX = (0 + random.nextDouble() * (0.8 - 0));
    positionY = (0.1 + random.nextDouble() * (0.8 - 0.1));
  }

  Timer? timer;
  int second = 30;
  void startTimer() {
  timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    setState(() {
      second--;
    });

    if (second < 0) {
      timer.cancel();
      showGameOverDialog(); // 👈 New popup
    }
  });
}
void showGameOverDialog() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width * 0.7,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Time's Up!",
                    style: TextStyle(
                      fontSize: (width / Responsive.designWidth) * 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Text(
                    "Your Score: $score",
                    style: TextStyle(
                      fontSize: (width / Responsive.designWidth) * 35,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: height * 0.04),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Get.to(const HomePage()); // Same as Submit
                    },
                    child: Text(
                      "Tap to Continue",
                      style: TextStyle(
                        fontSize: (width / Responsive.designWidth) * 30,
                        color: const Color.fromARGB(166, 207, 207, 11),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

  void showMyDialog() {
  if (_isDialogVisible) return;

  _isDialogVisible = true;

  showGeneralDialog(
    transitionDuration: const Duration(milliseconds: 500),
    barrierDismissible: false,
    barrierLabel: MaterialLocalizations.of(context).dialogLabel,
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center( // 👈 Center vertically and horizontally
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 0.7,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    "Target Game",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: (width / Responsive.designWidth) * 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Text(
                    "Instruction",
                    style: TextStyle(
                      fontSize: (width / Responsive.designWidth) * 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: height * 0.015),
                  Text(
                    "Tap as many targets as you can in the given 30 seconds. Tap continue to begin and submit when you are done.",
                    style: TextStyle(
                      fontSize: (width / Responsive.designWidth) * 28,
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        _isDialogVisible = false;
                        startTimer(); // Only start on initial instruction
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: (width / Responsive.designWidth) * 35,
                          color: const Color.fromARGB(166, 207, 207, 11),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

  double height = 0.0;
  double width = 0.0;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showMyDialog();
    });
    getRandomPosition();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    height = Responsive.screenHeight(context);
    width = Responsive.screenWidth(context);
    return Scaffold(
      body: GestureDetector(
        onTapUp: (TapUpDetails details) {
          Offset tapPosition = details.globalPosition;
          debugPrint('Container Position: (${(positionX*width)+(height * circleSize.values.elementAt(index))} ${(positionY*height)+(height * circleSize.values.elementAt(index))})');
          debugPrint("Tap Position Outside: (${tapPosition.dx}, ${(tapPosition.dy)-(height * 0.1)})");
          TargetGameServices.targetGameDataFirebase(
            patientId,
            0,
            ((positionX*width)+(height * circleSize.values.elementAt(index))),
            ((positionY*height)+(height * circleSize.values.elementAt(index))),
            (tapPosition.dx),
            ((tapPosition.dy)-(height * 0.1)),
            (circleSize.values.elementAt(index)),
          );
        },
        child: Container(
          height: height * 1,
          width: width * 1,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height * 0.1,
                width: width * 1,
                color: Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: (){
                        Get.to(const HomePage());
                      },
                      child: Text("Back",
                        style: TextStyle(
                          fontSize: (width / Responsive.designWidth) * 30,
                          color: const Color.fromARGB(166, 207, 207, 11),
                        ),
                      )
                    ),
                          IconButton(
                            onPressed: () {
                              showMyDialog(); // Show instructions on demand
                            },
                            icon: Icon(Icons.info_outline),
                            tooltip: 'Show Instructions',
                            color: const Color.fromARGB(166, 207, 207, 11),
                            iconSize: (width / Responsive.designWidth) * 30,
                          ),

                          TextButton(
                            onPressed: () {
                              timer!.cancel();
                              Get.to(const HomePage());
                            },
                            child: Text("Submit",
                              style: TextStyle(
                                fontSize: (width / Responsive.designWidth) * 30,
                                color: const Color.fromARGB(166, 207, 207, 11),
                          ),
                      )
                    ),
                  ],
                ),
              ),
              Center(
                child: (second>=0) ? Text(second.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: (width/Responsive.designWidth) * 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ) : Text("0",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: (width/Responsive.designWidth) * 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ),
              ),
              (second>=0) ? GestureDetector(
                //behavior: HitTestBehavior.translucent,
                onTapUp: (TapUpDetails details) {
                  debugPrint('Container Position: (${(positionX*width)+(height * circleSize.values.elementAt(index))} ${(positionY*height)+(height * circleSize.values.elementAt(index))})');
                  Offset tapPosition = details.globalPosition;
                  debugPrint("Tap Position Inside: (${tapPosition.dx}, ${(tapPosition.dy)-(height * 0.1)})");
                  TargetGameServices.targetGameDataFirebase(
                    patientId,
                    1,
                    ((positionX*width)+(height * circleSize.values.elementAt(index))),
                    ((positionY*height)+(height * circleSize.values.elementAt(index))),
                    (tapPosition.dx),
                    ((tapPosition.dy)-(height * 0.1)),
                    (circleSize.values.elementAt(index)),
                  );
                  getRandomPosition();
                  score++; // Increment score on successful hit
                  setState(() {});
                  
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: height * circleSize.keys.elementAt(index),
                  width: height * circleSize.keys.elementAt(index),
                  margin: EdgeInsets.only(left: (width * positionX),top: height * positionY),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent,
                  ),     
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: height * (circleSize.keys.elementAt(index)-0.03),
                      width: height * (circleSize.keys.elementAt(index)-0.03),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.yellow,
                      ),
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height: height * (circleSize.keys.elementAt(index)-0.06),
                          width: height * (circleSize.keys.elementAt(index)-0.06),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}