import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';

enum ShapeType { triangle, square, pentagon, hexagon, heptagon, octagon, nonagon, decagon, circle }

class ShapeModel {
  final int number;
  final ShapeType type;
  Offset position;
  RxBool isConnected;

  ShapeModel({
    required this.number,
    required this.type,
    required this.position,
    bool isConnected = false,
  }) : isConnected = isConnected.obs;
}