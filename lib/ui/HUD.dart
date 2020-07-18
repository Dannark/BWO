import 'package:BWO/game_controller.dart';
import 'package:BWO/ui/UIElement.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class HUD {
  bool isActive = true;
  List<UIElement> uiElelements = [];

  HUD() {}

  void draw(Canvas c) {
    if (!isActive) {
      return;
    }

    for (var ui in uiElelements) {
      if (ui.drawOnHUD) {
        ui.draw(c);
      }
    }
  }

  void addElement(UIElement newUi) {
    newUi.hudRef = this;
    uiElelements.add(newUi);
  }
}
