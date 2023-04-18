// ignore_for_file: file_names

import 'package:flutter/material.dart';

abstract class Effect {
  bool isAlive = true;

  Effect();

  void draw(Canvas c) {}
}
