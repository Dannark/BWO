import 'package:BWO/game_controller.dart';
import 'package:BWO/ui/ButtonUI.dart';
import 'package:flutter/material.dart';

class ButtonListUI {
  double x, y, width, height, spaceBetween;
  List<ButtonUI> buttonList = [];

  var _onPressedCallback;

  ButtonListUI(
    List<String> list,
    this.x,
    this.y,
    this.width,
    this.height, {
    int indexSelected = -1,
    double spaceBetween = 1,
    double fontSize = 10,
  }) {
    this.spaceBetween = spaceBetween;

    for (int i = 0; i < list.length; i++) {
      buttonList.add(ButtonUI(
        Rect.fromLTWH(x, y + spaceBetween + (height * i), width, height),
        list[i],
        fontSize: fontSize,
        canBeSelected: true,
        isSelected: i == indexSelected ? true : false,
      )..onPressedListener(
          callback: () {
            toggleButton(list[i], i);
          },
        ));
    }
  }

  void draw(Canvas c) {
    for (int i = 0; i < buttonList.length; i++) {
      buttonList[i].setBounds(
          Rect.fromLTWH(x, y + ((height + spaceBetween) * i), width, height));
      buttonList[i].draw(c);
    }
  }

  void setPos(double x, double y) {
    this.x = x;
    this.y = y;
  }

  Function toggleButton(String bName, bIndex) {
    buttonList.forEach((element) {
      if (element.text == bName) {
        element.isSelected = true;
        _onPressedCallback(bName, bIndex);
      } else {
        element.isSelected = false;
      }
    });
  }

  void onPressedListener({Function(String, int) callback}) {
    this._onPressedCallback = callback;
  }
}
