import 'package:flame/position.dart';
import 'package:flutter/material.dart';

class Frame {
  Paint boxPaint = Paint();
  Rect boxRect;

  List<Pixel> pixels = new List();

  double x, y;

  Frame(int posX, int posY, size, int worldSize, PixelGroup pixelsData) {
    this.x = posX.toDouble() * (worldSize / size);
    this.y = posY.toDouble() * (worldSize / size);
    Map<int, List<int>> columnList = pixelsData.rowsColorsId.asMap();

    columnList.forEach((ykey, row) {
      row.asMap().forEach((xKey, colorId) {
        if (colorId != 0) {
          int midPoint = row.length ~/ 2;
          pixels.add(Pixel(
            Position(
              (xKey - midPoint).toDouble(),
              (ykey - columnList.length + 1).toDouble(),
            ),
            size,
            worldSize,
            pixelsData.colors[colorId],
          ));
        }
      });
    });
  }

  void draw(Canvas c, double moveX, double moveY) {
    x = moveX;
    y = moveY;

    for (var pixel in pixels) {
      pixel.draw(c, x, y);
    }
  }
}

class PixelGroup {
  List<List<int>> rowsColorsId;
  Map<int, Color> colors;
  String tag;

  PixelGroup(this.rowsColorsId, this.colors, this.tag);
}

class Pixel {
  Position pivot;
  Position position;
  int pixelSize;
  int worldSize;
  Color color;

  Paint boxPaint = Paint();
  Rect boxRect;

  Pixel(this.position, this.pixelSize, this.worldSize, this.color) {
    pivot = Position(position.x, position.y);
    boxRect = Rect.fromLTWH(
      position.x * pixelSize,
      position.y * pixelSize,
      pixelSize.toDouble(),
      pixelSize.toDouble(),
    );
    boxPaint.color = color != null ? color : Colors.white;
  }

  void draw(Canvas c, double x, double y) {
    position.x = x;
    position.y = y;
    
    boxRect = Rect.fromLTWH(
      ((pivot.x) * pixelSize) + position.x,
      ((pivot.y) * pixelSize) + position.y,
      pixelSize.toDouble(),
      pixelSize.toDouble(),
    );
    c.drawRect(boxRect, boxPaint);
  }
}
