import 'package:flutter/material.dart';

class Tile {
  int posX;
  int posY;
  int size = 15;
  Color color;

  ///ground height from 0 to 255
  int height = 255;

  Paint boxPaint = Paint();
  Rect boxRect;

  Tile(this.posX, this.posY, this.height, this.size, this.color) {
    boxRect = Rect.fromLTWH(
      posX.toDouble() * size.toDouble(),
      posY.toDouble() * size.toDouble(),
      size.toDouble(),
      size.toDouble(),
    );
    boxPaint.color = color != null ? color : Colors.white;
  }

  void draw(Canvas c) {
    c.drawRect(boxRect, boxPaint);
  }
}
