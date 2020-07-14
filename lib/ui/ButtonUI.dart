import 'package:BWO/Utils/TapState.dart';
import 'package:flame/anchor.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonUI {
  Rect bounds;
  Paint p = Paint();

  TextConfig normalText;
  String text;

  Color normalColor;
  Color pressedColor;

  var onPressedCallback;

  ButtonUI(
    Rect bounds,
    this.text, {
    Color normalColor,
    Color pressedColor,
    Color fontColor,
  }) {
    this.bounds = Rect.fromLTWH(bounds.left - bounds.width / 2, bounds.top,
        bounds.width, bounds.height);
    this.normalColor =
        normalColor != null ? normalColor : Color.fromRGBO(216, 165, 120, 1);
    this.pressedColor =
        pressedColor != null ? pressedColor : Color.fromRGBO(50, 143, 249, 1);

    normalText = TextConfig(
      fontSize: 15,
      color: fontColor != null ? fontColor : Color.fromRGBO(224, 223, 168, 1),
      fontFamily: "Blocktopia",
    );
  }

  void draw(Canvas c) {
    p.color = normalColor;

    if (TapState.clickedAt(bounds)) {
      if (onPressedCallback != null) onPressedCallback();
    }

    if (TapState.currentClickingAt(bounds)) {
      p.color = pressedColor;
    }

    c.drawRect(bounds, p);

    normalText.render(c, text, Position(bounds.center.dx, bounds.center.dy),
        anchor: Anchor.center);
  }

  void onPressedListener({Function() callback}) {
    this.onPressedCallback = callback;
  }
}
