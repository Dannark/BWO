import 'package:BWO/map/ground.dart';
import 'package:BWO/map/tile.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';

import '../../map/map_controller.dart';
import '../../scene/game_scene.dart';
import '../../utils/tap_state.dart';
import '../player/player.dart';
import 'wall.dart';

class Foundation {
  final MapController _map;
  final Player _player;
  double left, top, width, height;
  dynamic foundationData;
  final List<Wall> wallList = [];
  final Map<String, Tile> tileList = {};
  bool isValidTerrain = true;

  Rect bounds = Rect.zero;

  WallLevel showWallLevel = WallLevel.auto;

  Paint p = Paint();
  final TextConfig _txt10 = TextConfig(
      fontSize: 10.0, color: Colors.blueGrey[700], fontFamily: "Blocktopia");

  Foundation(this.foundationData, this._map, this._player) {
    setup(foundationData);
  }

  void setup(dynamic mFoundationData) {
    foundationData = mFoundationData;

    for (var wall in wallList) {
      wall.destroy();
    }
    wallList.clear();

    left = double.parse(foundationData['x'].toString());
    top = double.parse(foundationData['y'].toString());
    width = double.parse(foundationData['w'].toString());
    height = double.parse(foundationData['h'].toString());

    var wallDataList = foundationData['walls'];

    for (var data in wallDataList) {
      var x = double.parse(data['x'].toString());
      var y = double.parse(data['y'].toString());
      var imgId = int.parse(data['id'].toString());

      var wall = Wall(x, y, imgId);
      wallList.add(wall);
      _map.addEntity(wall);
    }

    bounds = getBuildingArea();
  }

  void addWall(double x, double y, int imgId) {
    if (isInsideFoundation(x, y)) {
      var wall = Wall(x, y, imgId);

      var foundWall = wallList.firstWhere((element) => element.id == wall.id,
          orElse: () => null);

      if (foundWall == null) {
        if (_map.addEntity(wall)) {
          //if was added
          wallList.add(wall);
        }
      } else {
        foundWall.marketToBeRemoved = wall.marketToBeRemoved;
        foundWall.imageId = wall.imageId;
      }
    }

    switchWallHeight();
  }

  void save() {
    var foundationObject = fromListToObject();
    GameScene.serverController.sendMessage('onFoundationAdd', foundationObject);
  }

  dynamic fromListToObject() {
    var finalObject = {
      'owner': foundationData['owner'],
      'name': foundationData['name'],
      'x': foundationData['x'],
      'y': foundationData['y'],
      'w': foundationData['w'],
      'h': foundationData['h'],
      'walls': [],
      'floors': [],
      'furnitures': []
    };

    for (var item in wallList) {
      finalObject["walls"] = [...finalObject["walls"], item.toObject()];
    }
    tileList.forEach((key, value) {
      finalObject["floors"] = [...finalObject["floors"], value.toObject()];
    });

    return finalObject;
  }

  void deleteWall(double x, double y) {
    if (isInsideFoundation(x, y)) {
      var wall = Wall(x, y, 1);
      var foundWall = wallList.firstWhere((element) => element.id == wall.id,
          orElse: () => null);

      if (foundWall != null) {
        wallList.remove(foundWall);
        foundWall.destroy();
      }
    }
  }

  void addFloor(double x, double y, int imgId) {
    if (isInsideFoundation(x, y)) {
      var posX = x.floor();
      var posY = y.floor();

      var t = Tile(posX, posY, Ground.lowGrass, 16, null,
          tileSpritePath: 'floors/floor$imgId.png', idImg: imgId);
      tileList['_${posX}_$posY'] = t;

      _map.map[posY][posX][0] = t;
    }
  }

  void drawBuildArea(Canvas c) {
    bounds = getBuildingArea();
    if (isValidTerrain) {
      p.color = Color.fromRGBO(55, 59, 150, .2);
    } else {
      p.color = Color.fromRGBO(203, 43, 49, .2);
    }

    c.drawRect(bounds, p);

    _drawLineGrid(c);

    _txt10.render(c, 'Building area', Position(bounds.left, bounds.bottom));
  }

  void _drawLineGrid(Canvas c) {
    p.color = Color.fromRGBO(55, 59, 150, .02);
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        p.strokeWidth = 0.5;
        if (x % 4 == 0 && y % 4 == 0) {
          p.strokeWidth = 2.5;
        }
        //vertical line
        c.drawLine(
          Offset(bounds.left + (x * 16), bounds.top),
          Offset(bounds.left + (x * 16), bounds.bottom),
          p,
        );
        //horizontal line
        c.drawLine(
          Offset(bounds.left, bounds.top + (y * 16)),
          Offset(bounds.right, bounds.top + (y * 16)),
          p,
        );
      }
    }
  }

  Rect getBuildingArea() {
    var offset = TapState.worldToScreenPoint(_map);

    var area = Rect.fromLTWH(
      (left * 16) + offset.dx,
      (top * 16) + offset.dy,
      width * 16,
      height * 16,
    );

    return area;
  }

  bool isInsideFoundation(double posX, double posY) {
    return posX >= left &&
        posX < (left + width) &&
        posY >= top &&
        posY <= (top + height);
  }

  void switchWallHeight({bool isBuildingMode = false}) {
    for (var wall in wallList) {
      if (showWallLevel == WallLevel.auto) {
        if (isInsideFoundation(
            _player.posX.toDouble(), _player.posY.toDouble())) {
          var leftRow = left.floor() == wall.posX;
          var rightRow = (left.ceil() + width - 1) == wall.posX;
          var topLine = (top + 1).floor() == wall.posY;

          if (leftRow || rightRow || topLine) {
            wall.showLow = false;
          } else {
            wall.showLow = true;
          }
        } else {
          wall.showLow = false;
        }
      } else if (showWallLevel == WallLevel.hight) {
        wall.showLow = false;
      } else {
        wall.showLow = true;
      }

      wall.showCollisionBox = isBuildingMode;
    }
  }
}
