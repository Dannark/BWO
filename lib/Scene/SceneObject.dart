import 'package:flutter/material.dart';

abstract class SceneObject {
  SceneObject();

  void draw(Canvas c) {}

  void update() {}
}
