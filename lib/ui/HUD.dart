import 'package:BWO/game_controller.dart';
import 'package:BWO/ui/UIElement.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class HUD {
  bool isActive = true;
  List<UIElement> _uiElelements = [];

  HUD() {}

  void draw(Canvas c) {
    if (!isActive) {
      return;
    }

    for (var ui in _uiElelements) {
      ui.draw(c);
    }
  }

  void addElement(UIElement newUi) {
    _uiElelements.add(newUi);
  }
}
