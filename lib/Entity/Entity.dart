import 'package:flutter/material.dart';

abstract class Entity{
  int posX;
  int posY;

  Entity(this.posX, this.posY);

  void draw(Canvas c){}
}