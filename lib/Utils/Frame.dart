import 'package:BWO/game_controller.dart';
import 'package:flame/position.dart';
import 'package:flutter/material.dart';

class Frames {
  Paint boxPaint = Paint();
  Rect boxRect;

  List<List<Pixel>> listOfPixelsGroup = new List();

  double x, y;

  int _currentFrameListId = 0;
  double _timeInFuture = 0;

  Frames(int posX, int posY, size, int worldSize, PixelGroup pixelsData) {
    this.x = posX.toDouble() * (worldSize / size);
    this.y = posY.toDouble() * (worldSize / size);

    pixelsData.listOfRowsColorsId.forEach((rowsColorsId) {
      Map<int, List<int>> columnList = rowsColorsId.asMap();

      List<Pixel> pixel = List();
      
      columnList.forEach((ykey, row) {
        row.asMap().forEach((xKey, colorId) {
          if (colorId != 0) {
            int midPoint = row.length ~/ 2;

            Pixel p = Pixel(
              Position(
                (xKey - midPoint).toDouble(),
                (ykey - columnList.length + 1).toDouble(),
              ),
              size,
              worldSize,
              pixelsData.colors[colorId],
            );

            pixel.add(p);
          }
        });  
      });

      listOfPixelsGroup.add(pixel);
    });
  }

  void draw(Canvas c, double moveX, double moveY, double delay) {
    x = moveX;
    y = moveY;
    if(GameController.time > _timeInFuture){
      _timeInFuture = GameController.time + delay;

      _currentFrameListId++;
      if(_currentFrameListId >= listOfPixelsGroup.length){
        _currentFrameListId = 0;
      }
    }
    
    if(delay <= 0.01){
      _currentFrameListId = 0;
    }

    for (var pixelGroup in listOfPixelsGroup[_currentFrameListId]) {
      pixelGroup.draw(c, x, y);
    }
  }
}

class PixelGroup {
  List<List<List<int>>> listOfRowsColorsId;
  Map<int, Color> colors;
  String tag;

  PixelGroup(this.listOfRowsColorsId, this.colors, this.tag);
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
