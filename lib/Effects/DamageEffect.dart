import 'dart:math';
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

  void addText(int damage, bool isMine) {
    damages.add(DamageText(damage, isMine));
  }
}

class DamageText {
  int damage = 0;
  double initialFontSize = 26;

  double posX, posY;
  double driftX = 0;
  double driftY = -32;
  double extraSpeedY = 0;
  int xRandomDirection = 1;

  double lifeTime = 0;
  bool markedToBeDestroyed = false;

  bool isMine = false;

  DamageText(this.damage, this.isMine) {
    lifeTime = GameController.time + 1.4;

    xRandomDirection = Random().nextInt(4) - 2;
  }

  void draw(Canvas c, double x, double y) {
    if (posX == null) {
      posX = x;
      posY = y;
    }
    extraSpeedY -= 0.06; //extraSpeedY * 0.1
    driftY -= 170 * GameController.deltaTime + extraSpeedY;
    driftX += 15 * GameController.deltaTime * xRandomDirection;
    initialFontSize =
        lerpDouble(initialFontSize, 8, GameController.deltaTime * 1);
    TextConfig textConfig = TextConfig(
        fontSize: initialFontSize,
        color: isMine ? Colors.white : Color.fromRGBO(229, 184, 46, 1),
        fontFamily: "Blocktopia");
    textConfig.render(c, "$damage", Position(posX + driftX, posY + driftY));

    if (GameController.time > lifeTime) {
      markedToBeDestroyed = true;
    }
  }
}
