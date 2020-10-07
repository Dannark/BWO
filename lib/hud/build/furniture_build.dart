import 'package:flutter/material.dart';

import '../../entity/wall/door.dart';
import '../../entity/wall/furniture.dart';
import '../../map/map_controller.dart';
import '../../utils/tap_state.dart';

class FurnitureBuild {
  final Paint _p = Paint();

  double left, top, width, height;
  Rect bounds = Rect.zero;

  bool isValidTerrain = false;
  final MapController _map;

  dynamic furnitureData;
  String furnitureId;

  FurnitureBuild(dynamic mFurnitureData, this._map) {
    setup(mFurnitureData);
  }

  void setup(dynamic mFurnitureData) {
    furnitureData = mFurnitureData;
    if (furnitureData == null) return;

    left = furnitureData['x'].toDouble();
    top = furnitureData['y'].toDouble();
    width = furnitureData['w'].toDouble();
    height = furnitureData['h'].toDouble();
    furnitureId = furnitureData['id'];

    bounds = getCollisionArea();
  }

  void drawCollisionArea(Canvas c) {
    bounds = getCollisionArea();

    if (isValidTerrain) {
      _p.color = Color.fromRGBO(18, 233, 81, .25);
    } else {
      _p.color = Color.fromRGBO(203, 43, 49, .2);
    }

    c.drawRect(bounds, _p);

    _drawLineGrid(c);

    //_txt10.render(c, 'Block area', Position(bounds.left, bounds.bottom));
  }

  Rect getCollisionArea() {
    var offset = TapState.worldToScreenPoint(_map);

    var area = Rect.fromLTWH(
      (left * 16 * _map.scale) + offset.dx,
      (top * 16 * _map.scale) + offset.dy,
      width * 16 * _map.scale,
      height * 16 * _map.scale,
    );

    return area;
  }

  void _drawLineGrid(Canvas c) {
    _p.color = Color.fromRGBO(55, 59, 150, .02);
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        _p.strokeWidth = 0.5;
        if (x % 4 == 0 && y % 4 == 0) {
          _p.strokeWidth = 2.5;
        }
        //vertical line
        c.drawLine(
          Offset(bounds.left + (x * 16 * _map.scale), bounds.top),
          Offset(bounds.left + (x * 16 * _map.scale), bounds.bottom),
          _p,
        );
        //horizontal line
        c.drawLine(
          Offset(bounds.left, bounds.top + (y * 16 * _map.scale)),
          Offset(bounds.right, bounds.top + (y * 16 * _map.scale)),
          _p,
        );
      }
    }
  }

  Furniture getFurniture() {
    return Furniture(left, top, width, height, furnitureId);
  }

  Door getDoor() {
    return Door(left, top, width, height, furnitureId);
  }
}
