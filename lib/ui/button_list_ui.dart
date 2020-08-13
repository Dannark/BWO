import 'package:flutter/material.dart';

import 'button_ui.dart';
import 'hud.dart';
import 'ui_element.dart';

class ButtonListUI extends UIElement {
  double x, y, width, height, spaceBetween;
  List<ButtonUI> buttonList = [];

  Function(String, int) onPressedListener;

  ButtonListUI(
    HUD hudRef,
    List<String> list,
    this.x,
    this.y,
    this.width,
    this.height, {
    int indexSelected = -1,
    this.spaceBetween = 1,
    double fontSize = 10,
  }) : super(hudRef) {
    for (var i = 0; i < list.length; i++) {
      var b = ButtonUI(
        hudRef,
        Rect.fromLTWH(x, y + spaceBetween + (height * i), width, height),
        list[i],
        fontSize: fontSize,
        canBeSelected: true,
        isSelected: i == indexSelected ? true : false,
      );

      b.onPressedListener = () {
        toggleButton(list[i], i);
      };

      buttonList.add(b);
    }
  }

  void draw(Canvas c) {
    for (var i = 0; i < buttonList.length; i++) {
      buttonList[i].bounds =
          Rect.fromLTWH(x, y + ((height + spaceBetween) * i), width, height);
      buttonList[i].draw(c);
    }
  }

  void setPos(double x, double y) {
    this.x = x;
    this.y = y;
  }

  void toggleButton(String bName, int bIndex) {
    for (var bt in buttonList) {
      if (bt.text == bName) {
        bt.isSelected = true;
        onPressedListener(bName, bIndex);
      } else {
        bt.isSelected = false;
      }
    }
  }
}
