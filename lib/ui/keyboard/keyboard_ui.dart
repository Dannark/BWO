import 'package:flame/position.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../game_controller.dart';
import '../../utils/tap_state.dart';
import 'key_button.dart';
import 'key_model.dart';
import 'key_ui_listener.dart';

// ignore: avoid_classes_with_only_static_members
class KeyboardUI {
  static final Map<int, List<KeyModel>> _keyList = {
    0: [
      KeyModel('1', 1),
      KeyModel('2', 1),
      KeyModel('3', 1),
      KeyModel('4', 1),
      KeyModel('5', 1),
      KeyModel('6', 1),
      KeyModel('7', 1),
      KeyModel('8', 1),
      KeyModel('9', 1),
      KeyModel('0', 1),
    ],
    1: [
      KeyModel('Q', 1),
      KeyModel('W', 1),
      KeyModel('E', 1),
      KeyModel('R', 1),
      KeyModel('T', 1),
      KeyModel('Y', 1),
      KeyModel('U', 1),
      KeyModel('I', 1),
      KeyModel('O', 1),
      KeyModel('P', 1),
    ],
    2: [
      KeyModel('A', 1, margin: .5),
      KeyModel('S', 1),
      KeyModel('D', 1),
      KeyModel('F', 1),
      KeyModel('G', 1),
      KeyModel('H', 1),
      KeyModel('J', 1),
      KeyModel('K', 1),
      KeyModel('L', 1),
    ], //'Ç'
    3: [
      KeyModel('⊼', 1.5, color: Colors.blueGrey[200]), //⊻ ⊼ ⌅
      KeyModel('Z', 1),
      KeyModel('X', 1),
      KeyModel('C', 1),
      KeyModel('V', 1),
      KeyModel('B', 1),
      KeyModel('N', 1),
      KeyModel('M', 1),
      KeyModel('⌫', 1.5, color: Colors.blueGrey[200])
    ], //⇧ ⌅
    4: [
      KeyModel('123', 1.5, color: Colors.blueGrey[200]),
      KeyModel(',', 1, color: Colors.blueGrey[200]),
      KeyModel('_', 5),
      KeyModel('.', 1, color: Colors.blueGrey[200]),
      KeyModel('➢', 1.5, color: Colors.blue, txtColor: Colors.white) //⏎ ↵ ⤴
    ]
  };

  static final List<KeyButton> _buttons = [];

  static KeyUIListener _keyUIListener;

  static Rect bounds;
  static double paddingX = 10;
  static double paddingY = 10;
  static double keyHeight = 40;
  static double height = 0;
  static final Paint _p = Paint();

  static Color keyBGColor = Colors.white70;
  static Color keyTxtColor = Colors.grey[800];

  static bool isEnable = false;
  static bool _isOpening = false;
  static bool _isCapitalized = true;

  static void build() {
    height = _keyList.length * keyHeight + paddingY;

    bounds = Rect.fromLTWH(
      0,
      GameController.screenSize.height - height,
      GameController.screenSize.width,
      height,
    );

    _keyList.forEach((lineIndex, lineKeys) {
      var xItem = 0.0;

      for (var i = 0; i < lineKeys.length; i++) {
        var obj = lineKeys[i];
        xItem += obj.margin;

        _buttons.add(KeyButton(Position(xItem, lineIndex.toDouble()), obj));

        if (obj is KeyModel) {
          xItem += obj.widthOnGrid;
        } else {
          xItem++;
        }
      }
    });
  }

  static void draw(Canvas c) {
    if (isEnable == false) {
      return;
    }

    bounds = Rect.fromLTWH(
      0,
      GameController.screenSize.height - height,
      GameController.screenSize.width,
      height,
    );

    if (TapState.clickedAt(KeyboardUI.getOutbounds()) && _isOpening == false) {
      KeyboardUI.closeKeyboard();
    }

    _p.color = Colors.blueGrey[100];
    c.drawRect(bounds, _p);

    for (var element in _buttons) {
      element.draw(c);
    }

    _isOpening = false;
  }

  static void onPressed(String keyName) {
    for (var element in _buttons) {
      if (element.keyText != keyName) {
        element.initializeAnimation(AnimationType.explosion);
        switchCaptalize(isCap: false);
      }
    }

    var notAllowed = ['⊼', '⌫', '123', '⤴', '➢'];
    if (notAllowed.contains(keyName) == false) {
      _keyUIListener.onKeyPressed(keyName);
    }

    if (keyName == '⌫') {
      _keyUIListener.onBackspacePressed();
    }

    if (keyName == '⊼') {
      switchCaptalize(isCap: !_isCapitalized);
    }

    if (keyName == '➢') {
      _keyUIListener.onConfirmPressed();
      closeKeyboard();
    }
  }

  static Rect getOutbounds() {
    return Rect.fromLTWH(0, 0, bounds.width, bounds.top);
  }

  static void _resetAnimation() {
    //resets animation with default open animation
    for (var element in _buttons) {
      element.initializeAnimation(AnimationType.roll3dBottomCenter);
    }
  }

  static void openKeyboard(KeyUIListener keyUIListener) {
    isEnable = true;
    _isOpening = true;
    _resetAnimation();
    _keyUIListener = keyUIListener;
  }

  static void closeKeyboard() {
    isEnable = false;
    _keyUIListener = null;
  }

  static void switchCaptalize({bool isCap = true}) {
    _isCapitalized = isCap;

    for (var button in _buttons) {
      if (_isCapitalized) {
        button.keyText = button.keyText.toUpperCase();
      } else {
        button.keyText = button.keyText.toLowerCase();
      }
    }
  }
}
