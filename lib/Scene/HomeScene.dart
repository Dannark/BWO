import 'package:BWO/Scene/SceneObject.dart';
import 'package:BWO/ui/UICharacterCreation.dart';
import 'package:flutter/material.dart';

class HomeScene extends SceneObject {
  UICharacterCreation _uiCharacterCreation = UICharacterCreation();

  HomeScene();

  @override
  void draw(Canvas c) {
    super.draw(c);

    _uiCharacterCreation.draw(c);
  }

  @override
  void update() {
    super.update();
  }
}
