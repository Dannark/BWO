import 'dart:ui';

import 'package:BWO/game_controller.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';

class DamageEffect {
  List<DamageText> damages = [];

  void draw(Canvas c, double x, double y) {
    for (var textDmage in damages) {
      textDmage.draw(c, x, y);
    }

    damages.removeWhere((element) => element.markedToBeDestroyed);
  }

  void addText(int damage) {
    damages.add(DamageText(damage));
  }
}

class DamageText {
  int damage = 0;
  double initialFontSize = 22;

  double posX, posY;
  double driftX = 16;
  double driftY = -32;
  double extraSpeedY = 2;

  double lifeTime = 0;
  bool markedToBeDestroyed = false;

  DamageText(this.damage) {
    lifeTime = GameController.time + 1.25;
  }

  void draw(Canvas c, double x, double y) {
    if (posX == null) {
      posX = x;
      posY = y;
    }
    extraSpeedY -= 0.06; //extraSpeedY * 0.1
    driftY -= 25 * GameController.deltaTime + extraSpeedY;
    driftX += 12 * GameController.deltaTime;
    initialFontSize =
        lerpDouble(initialFontSize, 10, GameController.deltaTime * 1);
    TextConfig textConfig = TextConfig(
        fontSize: initialFontSize, color: Colors.red, fontFamily: "Blocktopia");
    textConfig.render(c, "$damage", Position(posX + driftX, posY + driftY));

    if (GameController.time > lifeTime) {
      markedToBeDestroyed = true;
    }
  }
}
