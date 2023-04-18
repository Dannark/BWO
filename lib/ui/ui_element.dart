import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'hud.dart';

abstract class UIElement extends SpriteComponent {
  Rect bounds = Rect.zero;
  HUD hudRef;
  bool drawOnHUD = false;

  UIElement(this.hudRef) {
    hudRef.addElement(this);
  }
  void draw(Canvas c) {}
}
