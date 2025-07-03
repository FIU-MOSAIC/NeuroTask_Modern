import 'package:flutter/material.dart';

abstract class Game{
  String get title;
  String get route;
  String get info;//for tooltip of each game's button
  Icon get gameIcon; 
}