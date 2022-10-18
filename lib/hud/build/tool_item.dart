import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../ui/hud.dart';
import '../../ui/ui_element.dart';
import '../../utils/preload_assets.dart';
import '../../utils/tap_state.dart';

class ToolItem extends UIElement {
  final Paint _p = Paint();
  String spriteName;
  Sprite sprite;
  Offset pos = Offset.zero;

  final TextPaint _text = TextPaint(
      style: TextStyle(
          fontSize: 12.0,
          color: Color.fromRGBO(62, 44, 40, 1),
          fontFamily: "Blocktopia"));

  Function(ToolItem) callback;

  bool isSelected = false;

  String name;

  ToolItem(this.spriteName, this.name, HUD hudRef, this.callback,
      {bool isBtSelected = false, Vector2 size})
      : super(hudRef) {
    isSelected = isBtSelected;
    loadSprite();
  }

  void loadSprite() async {
    sprite = PreloadAssets.getUiSprite(spriteName);
  }

  void draw(Canvas c) {
    if (sprite == null) return;

    bounds = Rect.fromLTWH(pos.dx - 16, pos.dy - 16, 32, 32);

    if (isSelected) {
      _p.color = Color.fromRGBO(127, 101, 66, .8);
    } else {
      _p.color = Color.fromRGBO(212, 189, 135, 1);
    }

    c.drawCircle(pos, 25, _p);
    sprite.render(c,
        position: Vector2(pos.dx - 16, pos.dy - 16), size: Vector2.all(2));

    _text.render(
        c, name, Vector2(bounds.bottomCenter.dx, bounds.bottomCenter.dy + 24),
        anchor: Anchor.bottomCenter);

    checkPress();
  }

  void checkPress() {
    if (TapState.clickedAt(bounds) && callback != null) {
      callback(this);
    }
  }
}
