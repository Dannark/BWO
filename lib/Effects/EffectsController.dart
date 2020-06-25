import 'package:BWO/Effects/Effect.dart';
import 'package:flutter/material.dart';

class EffectsController{
  static final List<Effect> _effects = List();

  static void draw(Canvas c){
    for (var effect in _effects) {
      effect.draw(c);
    }
  }
}