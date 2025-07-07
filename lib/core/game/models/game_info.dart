import 'package:flutter/material.dart';

class GameInfo {
  final String title;
  final IconData gameIcon;
  final String route;
  final String description;
  final bool isImplemented;

  const GameInfo({
    required this.title,
    required this.gameIcon,
    required this.route,
    required this.description,
    this.isImplemented = false,
  });
} 