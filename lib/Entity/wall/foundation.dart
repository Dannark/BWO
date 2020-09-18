import 'package:BWO/entity/wall/Roof.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';

import '../../map/ground.dart';
import '../../map/map_controller.dart';
import '../../map/tile.dart';
import '../../scene/game_scene.dart';
import '../../utils/tap_state.dart';
import '../player/player.dart';
import 'door.dart';
import 'furniture.dart';
import 'wall.dart';

class Foundation {
  final MapController _map;
  final Player _player;
  double left, top, width, height;
  dynamic foundationData;
  //final List<Wall> wallList = [];
  final Map<String, Wall> wallList = {};
  final Map<String, Tile> tileList = {};
  final Map<String, Furniture> furnitureList = {};
  Roof roof = Roof();
  bool isValidTerrain = true;

  Rect bounds = Rect.zero;

  WallLevel showWallLevel = WallLevel.upstair;
  bool _isPreviousInsideFoundation = false;

  Paint p = Paint();
  final TextConfig _txt10 = TextConfig(
      fontSize: 10.0, color: Colors.blueGrey[700], fontFamily: "Blocktopia");

  Foundation(this.foundationData, this._map, this._player) {
    setup(foundationData);
  }

  void setup(dynamic mFoundationData) {
    foundationData = mFoundationData;

    wallList.forEach((key, value) {
      value.destroy();
    });
    wallList.clear();

    left = foundationData['x'].toDouble();
    top = foundationData['y'].toDouble();
    width = foundationData['w'].toDouble();
    height = foundationData['h'].toDouble();

    var wallDataList = foundationData['walls'];

    for (var data in wallDataList) {
      var x = data['x'].toDouble();
      var y = data['y'].toDouble();
      var imgId = data['id'];

      var wall = Wall(x, y, imgId, this);
      wallList['_${wall.posX}_${wall.posY}'] = wall;
      _map.addEntity(wall);
    }

    bounds = getBuildingArea();
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

    wallList.forEach((key, item) {
      finalObject["walls"] = [...finalObject["walls"], item.toObject()];
    });

    tileList.forEach((key, value) {
      finalObject["floors"] = [...finalObject["floors"], value.toObject()];
    });

    furnitureList.forEach((key, value) {
      finalObject["furnitures"] = [
        ...finalObject["furnitures"],
        value.toObject()
      ];
    });

    return finalObject;
  }

  void addWall(double x, double y, int imgId) {
    if (isInsideFoundation(x, y)) {
      var wall = Wall(x, y, imgId, this);
      switchWallHeight(wall);

      var foundWall = wallList[wall.id];

      if (foundWall == null) {
        _map.addEntity(wall);
        wallList['_${wall.posX}_${wall.posY}'] = wall;
      } else {
        foundWall.marketToBeRemoved = wall.marketToBeRemoved;
        foundWall.imageId = wall.imageId;
      }
    }
  }

  void deleteWall(double x, double y) {
    if (isInsideFoundation(x, y)) {
      var wall = Wall(x, y, 1, this);

      var foundWall = wallList[wall.id];

      if (foundWall != null) {
        wallList.remove(wall.id);
        foundWall.destroy();
      }
    }
  }

  void addFloor(double x, double y, int imgId) {
    if (isInsideFoundation(x, y)) {
      var posX = x.floor();
      var posY = y.floor();

      var t = Tile(posX, posY, Ground.lowGrass, 16, null,
          tileSpritePath: 'floor$imgId', idImg: imgId);
      tileList['_${posX}_$posY'] = t;

      if (_map.map[posY] == null) {
        _map.map[posY] = {posX: null}; //initialize line
      }
      if (_map.map[posY][posX] == null) {
        _map.map[posY][posX] = {0: null}; //initialize line
      }
      _map.map[posY][posX][0] = t;
    }
  }

  void addFurniture(final Furniture f) {
    var found = furnitureList[f.id];

    if (found == null && f.imageId != null) {
      _map.addEntity(f);
      furnitureList[f.id] = f;
    } else {
      found.marketToBeRemoved = f.marketToBeRemoved;
    }
  }

  void deleteFurniture(double x, double y) {
    Furniture toBeDeleted;
    furnitureList.forEach((key, furniture) {
      if (furniture.isInside(x.floor(), y.floor())) {
        toBeDeleted = furniture;
      }
    });
    if (toBeDeleted != null) {
      furnitureList.remove(toBeDeleted.id);
      toBeDeleted.destroy();
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

  /// Using Grid coordinates
  bool isInsideFoundation(double posX, double posY,
      {double wPoint = 0, double hPoint = 0}) {
    return posX >= left &&
        posX + wPoint < (left + width) &&
        posY >= top &&
        posY + hPoint <= (top + height);
  }

  void switchDoor({bool isBuildingMode = false}) {
    furnitureList.forEach((key, furniture) {
      if (furniture is Door) {
        var isOpen = _player.posY.toDouble() >= furniture.posY - 2 &&
            _player.posY.toDouble() <= furniture.posY + 2 &&
            _player.posX.toDouble() >= furniture.posX - 2 &&
            _player.posX.toDouble() <= furniture.posX + 2;
        furniture.isOpen = isOpen;
        furniture.isOpen = isBuildingMode ? false : furniture.isOpen;
      }
    });
  }

  void switchWallHeightAll({bool isBuildingMode = false}) {
    wallList.forEach((key, wall) {
      switchWallHeight(wall);
    });
    _isPreviousInsideFoundation =
        isInsideFoundation(_player.posX.toDouble(), _player.posY.toDouble());
  }

  void switchWallHeight(Wall wall, {bool isBuildingMode = false}) {
    var isCurrentInsideFoundation =
        isInsideFoundation(_player.posX.toDouble(), _player.posY.toDouble());

    if (isCurrentInsideFoundation != _isPreviousInsideFoundation) {
      if (isCurrentInsideFoundation) {
        //enter house
        showWallLevel = WallLevel.mid;
        wall.showLow = false;
      } else {
        //leave house
        showWallLevel = WallLevel.upstair;
        wall.showLow = false;
      }
    }

    if (showWallLevel == WallLevel.mid) {
      var leftRow = left.floor() == wall.posX;
      var rightRow = (left.ceil() + width - 1) == wall.posX;
      var topLine = (top + 1).floor() == wall.posY;

      if (leftRow || rightRow || topLine) {
        wall.showLow = false;
      } else {
        wall.showLow = true;
      }
    } else if (showWallLevel == WallLevel.hight) {
      wall.showLow = false;
    } else if (showWallLevel == WallLevel.low) {
      wall.showLow = true;
    }

    wall.showCollisionBox = isBuildingMode;
    roof.show = (showWallLevel == WallLevel.upstair);
  }

  void drawRoof(Canvas c) {
    if (!roof.show) return;

    for (var y = top + 4; y < top + height; y++) {
      var firstWallPos = 0.0;
      var lastWallPos = 0;
      var wallsOnLine = 0;

      for (var x = left; x < left + width; x++) {
        var wall = wallList['_${x.toInt()}_${y.toInt() + 1}'];

        if (wall != null) {
          wallsOnLine++;
          if (firstWallPos == 0) firstWallPos = x;
          lastWallPos = x.toInt();
        }

        if (x == left + width - 1 && wallsOnLine > 1) {
          //last pos
          var lineSize = lastWallPos - firstWallPos;

          for (var i = 0; i <= lineSize; i++) {
            roof?.draw(c, (firstWallPos + i) * 16, y * 16 - 64);
          }
        }
      }
    }
  }
}
