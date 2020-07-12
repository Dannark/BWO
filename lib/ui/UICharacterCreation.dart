import 'package:BWO/game_controller.dart';
import 'package:BWO/ui/InputTextUI.dart';
import 'package:BWO/ui/UIElement.dart';
import 'package:flame/anchor.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';

class UICharacterCreation {
  Paint p = Paint();
  Paint playerSelect = Paint();

  InputTextUI _inputTextUI = InputTextUI(
      Position(GameController.screenSize.width / 2, 290),
      "Player1",
      "Player Name");

  TextConfig title =
      TextConfig(fontSize: 22.0, color: Colors.white, fontFamily: "Blocktopia");
  TextConfig smallText =
      TextConfig(fontSize: 14.0, color: Colors.white, fontFamily: "Blocktopia");

  UICharacterCreation() {}

  void draw(Canvas c) {
    p.color = Colors.blueGrey[800];
    c.drawRect(
        Rect.fromLTWH(0, 0, GameController.screenSize.width,
            GameController.screenSize.height),
        p);

    title.render(c, "Character Creation",
        Position(GameController.screenSize.width / 2, 70),
        anchor: Anchor.bottomCenter);

    playerSelect.color = Colors.blueGrey;
    playerSelect.strokeWidth = 1;
    playerSelect.style = PaintingStyle.stroke;

    c.drawRect(
        Rect.fromLTRB(100, 100, GameController.screenSize.width - 100, 250),
        playerSelect);
    _inputTextUI.draw(c);
  }
}
