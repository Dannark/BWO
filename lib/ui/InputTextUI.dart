import 'package:BWO/game_controller.dart';
import 'package:BWO/ui/Keyboard/KeyUIListener.dart';
import 'package:BWO/ui/Keyboard/KeyboardUI.dart';
import 'package:BWO/ui/UIElement.dart';
import 'package:flame/anchor.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';

class InputTextUI extends UIElement implements KeyUIListener {
  Position pos;
  String inputText = "Player1";
  String placeHolder = "Text Example";

  double width = 200;
  double height = 40;
  Rect bounds;
  double padding = 5;

  Paint p = Paint();

  KeyboardUI _keyboardUI;

  InputTextUI(this.pos, this.inputText, this.placeHolder) {
    _keyboardUI = KeyboardUI(this);
  }

  TextConfig smallText = TextConfig(
      fontSize: 18.0, color: Colors.grey[500], fontFamily: "Blocktopia");

  void draw(Canvas c) {
    p.color = Colors.blueGrey[50];

    bounds =
        Rect.fromLTWH(pos.x - width / 2, pos.y - height / 2, width, height);
    c.drawRRect(RRect.fromRectAndRadius(bounds, Radius.circular(5)), p);

    smallText.render(
      c,
      inputText,
      Position(bounds.left + padding, bounds.center.dy),
      anchor: Anchor.centerLeft,
    );

    _keyboardUI.draw(c);
  }

  @override
  void onConfirmPressed(String text) {
    inputText = text;
    print("Confirm Pressed");
  }

  @override
  void onKeyPressed(String text) {
    inputText = text;
    smallText = TextConfig(
        fontSize: 18.0, color: Colors.grey[800], fontFamily: "Blocktopia");
  }
}
