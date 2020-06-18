import 'dart:ui';
import 'package:BWO/Map/ground.dart';
import 'package:BWO/Map/tile.dart';
import 'package:flutter/material.dart';

class Tree extends Tile{

  List<Tile> tiles = new List();

  Tree(int posX, int posY, int height, int size, Color color) : super(posX, posY, height, size, color){

    boxPaint.color = color != null ? color : Colors.brown[800];

    tiles.add( Tile(posX + 2, posY - 1, height, size, Colors.green[900]) );
    tiles.add( Tile(posX -1, posY, height, size, Colors.brown[900]));

    tiles.add( Tile(posX + 2, posY - 1, height, size, Colors.green[900]));
    tiles.add( Tile(posX + 1, posY - 1, height, size, Colors.green[900]));
    tiles.add( Tile(posX + 0, posY - 1, height, size, Colors.green[900]));
    tiles.add( Tile(posX - 1, posY - 1, height, size, Colors.green[900]));
    tiles.add( Tile(posX - 2, posY - 1, height, size, Colors.green[800]));
    tiles.add( Tile(posX - 3, posY - 1, height, size, Colors.green[700]));
    
    tiles.add( Tile(posX + 1, posY - 2, height, size, Colors.green[900]));
    tiles.add( Tile(posX, posY - 2, height, size, Colors.green[900]));
    tiles.add( Tile(posX - 1, posY - 2, height, size, Colors.green[900]));
    tiles.add( Tile(posX - 2, posY - 2, height, size, Colors.green[800]));
    tiles.add( Tile(posX - 3, posY - 2, height, size, Colors.green[700]));

    tiles.add( Tile(posX+1, posY - 3, height, size, Colors.green[900]));
    tiles.add( Tile(posX, posY - 3, height, size, Colors.green[900]));
    tiles.add( Tile(posX-1, posY - 3, height, size, Colors.green[800]));
    tiles.add( Tile(posX-2, posY - 3, height, size, Colors.green[700]));

    tiles.add( Tile(posX, posY - 4, height, size, Colors.green[900]));
    tiles.add( Tile(posX-1, posY - 4, height, size, Colors.green[800]));
    tiles.add( Tile(posX-2, posY - 4, height, size, Colors.green[800]));

    tiles.add( Tile(posX, posY - 5, height, size, Colors.green[900]));
    tiles.add( Tile(posX-1, posY - 5, height, size, Colors.green[800]));

    tiles.add( Tile(posX-1, posY - 6, height, size, Colors.green[800]));

    tiles.add( Tile(posX-1, posY - 7, height, size, Colors.green[800]));
  }

  @override
  void draw(Canvas c) {

    c.drawRect(boxRect, boxPaint);

    for (var tile in tiles) {
      tile.draw(c);
    }
  }
}
