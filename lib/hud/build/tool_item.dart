import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../../game_controller.dart';
import '../../ui/hud.dart';
import '../../ui/ui_element.dart';
import '../../utils/tap_state.dart';

class ToolItem extends UIElement {
  final Paint _p = Paint();
  String spriteName;
  Sprite sprite;
  Offset pos;

  Function(ToolItem) callback;

  bool isSelected = false;

  ToolItem(this.spriteName, this.pos, HUD hudRef, this.callback,
      {bool isBtSelected = false})
      : super(hudRef) {
    isSelected = isBtSelected;
    loadSprite();
  }

  void loadSprite() async {
    sprite = await Sprite.loadSprite("ui/$spriteName.png");
  }

  void draw(Canvas c) {
    if (sprite == null) return;

    bounds = Rect.fromLTWH(pos.dx, pos.dy, 32, 32);

    if (isSelected) {
      _p.color = Color.fromRGBO(127, 101, 66, .8);
    } else {
      _p.color = Color.fromRGBO(212, 189, 135, 1);
    }

    c.drawCircle(pos, 25, _p);
    sprite.renderScaled(c, Position(pos.dx - 16, pos.dy - 16), scale: 2);

    checkPress();
  }

  void checkPress() {
    if (TapState.clickedAt(bounds)) {
      print('clicked at $spriteName');
      callback(this);
    }
  }
}
