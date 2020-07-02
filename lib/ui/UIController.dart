import 'package:BWO/ui/HUD.dart';
import 'package:BWO/ui/UIElement.dart';
import 'package:flutter/material.dart';

class UIController {
  HUD hud = HUD();

  UIController() {}

  void draw(Canvas c) {
    hud.draw(c);
  }
}
