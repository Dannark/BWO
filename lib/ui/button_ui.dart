import 'package:flame/anchor.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/tap_state.dart';
import 'hud.dart';
import 'ui_element.dart';

class ButtonUI extends UIElement {
  final Paint _p = Paint();

  TextConfig _normalText;
  String text;

  Color _normalColor;
  Color _pressedColor;

  Function() onPressedListener;

  bool canBeSelected = false;
  bool isSelected = false;

  ButtonUI(HUD hudRef, Rect bounds, this.text,
      {Color normalColor,
      Color pressedColor,
      Color fontColor,
      double fontSize = 15,
      this.canBeSelected = false,
      this.isSelected = false})
      : super(hudRef) {
    setPosition(bounds);

    _normalColor =
        normalColor != null ? normalColor : Color.fromRGBO(216, 165, 120, 1);
    _pressedColor =
        pressedColor != null ? pressedColor : Color.fromRGBO(50, 143, 249, 1);

    _normalText = TextConfig(
      fontSize: fontSize,
      color: fontColor != null ? fontColor : Color.fromRGBO(224, 223, 168, 1),
      fontFamily: "Blocktopia",
    );
  }

  void draw(Canvas c) {
    if (canBeSelected) {
      _p.color = isSelected ? _pressedColor : _normalColor;
    } else {
      _p.color = _normalColor;
    }

    if (TapState.clickedAtButton(this)) {
      isSelected = canBeSelected ? !isSelected : isSelected;
      if (onPressedListener != null) onPressedListener();
    }

    if (TapState.currentClickingAt(bounds)) {
      _p.color = _pressedColor;
    }

    c.drawRect(bounds, _p);

    _normalText.render(c, text, Position(bounds.center.dx, bounds.center.dy),
        anchor: Anchor.center);
  }

  void setPosition(Rect bounds) {
    this.bounds = Rect.fromLTWH(bounds.left - bounds.width / 2, bounds.top,
        bounds.width, bounds.height);
  }
}
