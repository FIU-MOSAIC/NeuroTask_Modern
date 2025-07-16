import 'package:get/get.dart';
import 'package:neurotask_ng/core/game/base/game_controller.dart';
import 'package:neurotask_ng/games/narration_reading_game/models/text_registry.dart';

class NarrationGameController extends GameController{
  List<String> sentences = TextRegistry.allSentences;
  List<String> receivedSentences = [];
  RxInt counter = 0.obs;
  int passageLimit = 10;

  @override
  void onGameStart(){
    sentences.shuffle();
    counter = 0.obs;
    //start timer and recorder
  }

  @override
  void onGameEnd(){
    //save results to firebase
    showCompletionDialog();
    //print("The test is complete");
  }

  @override
  void onGamePause(){

  }

  @override
  void onGameResume(){

  }

  @override
  void onGameReset(){

  }

  @override
  void onUserInteraction(dynamic data){
    if(data.runtimeType == String){
      receivedSentences.add(data);
    }
    if(counter < passageLimit){
      counter++;
      //print("the user read $counter sentences");
    }
    if(counter.toInt() == passageLimit){
      //print('the user finished the test in $timeElapsed seconds');
      onGameEnd();
    }
  }

}