import 'package:BWO/ui/HUD.dart';
import 'package:flutter/material.dart';

abstract class SceneObject {
  HUD hud = HUD();

  SceneObject() {}

  void draw(Canvas c) {}

  void update() {}
}
