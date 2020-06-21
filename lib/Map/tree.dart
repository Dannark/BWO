import 'dart:math';
import 'dart:ui';
import 'package:BWO/Entity/Entity.dart';
import 'package:BWO/Map/tile.dart';
import 'package:flame/sprite.dart';
import 'package:flame/sprite_batch.dart';
import 'package:flutter/material.dart';

class Tree extends Entity{
  int _tileSize;
  SpriteBatch _tree;

  Tree(int posX, int posY, this._tileSize) : super(posX, posY){
     loadSprite();
  }
  void loadSprite() async{
    _tree = await SpriteBatch.withAsset('trees/tree01.png');
    _tree.add(
      rect: Rect.fromLTWH(0, 0, 16, 16),
      offset: Offset(posX.toDouble() * _tileSize, posY.toDouble() * _tileSize),
      anchor: Offset(8,14),
      scale: _tileSize.toDouble(),
    );
  }

  void draw(Canvas c){
    if(_tree != null){
      _tree.render(c);
    }
  }
}
