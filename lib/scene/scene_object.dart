import 'package:flutter/material.dart';

import '../ui/hud.dart';

abstract class SceneObject {
  HUD hud = HUD();

  SceneObject();

  void draw(Canvas c) {}

  void update() {}
}
