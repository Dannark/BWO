import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../ui/hud.dart';

abstract class SceneObject extends SpriteComponent {
  HUD hud = HUD();

  SceneObject();

  void draw(Canvas c) {}

  void update(double dt) {}
}
