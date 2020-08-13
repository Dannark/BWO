import 'package:flutter/material.dart';

abstract class Effect {
  bool isAlive = true;

  Effect();

  void draw(Canvas c) {}
}
