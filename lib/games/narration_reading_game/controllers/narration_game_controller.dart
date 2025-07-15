import 'package:get/get.dart';
import 'package:neurotask_ng/core/game/base/game_controller.dart';
import 'package:flutter/material.dart';
import 'package:neurotask_ng/games/narration_reading_game/models/text_regristy.dart';

class NarrationGameController extends GameController implements Game{
  @override
  String get title => "Narration Reading";
  @override
  String get info => "Match all the animal pairs. Tap two cards to flip them. If they match, they stay revealed. Try to match all pairs with as few moves as possible!";
  @override
  String get route => "/narration-reading";
  @override
  Icon get gameIcon => Icon(Icons.record_voice_over);
  List<String> sentences = TextRegristy.allSentences;
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
    //save receivedStentences and test duration to firebase 
    showCompletionDialog();
    //print(receivedSentences);
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