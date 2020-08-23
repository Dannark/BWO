import 'dart:math';

import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';

import '../../map/map_controller.dart';
import '../../utils/tap_state.dart';
import 'wall.dart';

class Foundation {
  final MapController _map;
  double left, top, width, height;
  final List<Wall> wallList = [];

  Rect bounds = Rect.zero;

  Paint p = Paint();
  final TextConfig _txt10 = TextConfig(
      fontSize: 10.0, color: Colors.blueGrey[700], fontFamily: "Blocktopia");

  Foundation(dynamic foundationData, this._map) {
    // dynamic foundationData = [
    //   {
    //     'owner': 'Someone',
    //     'name': 'Home sweet home',
    //     'x': 0,
    //     'y': 0,
    //     'w': 16,
    //     'h': 16,
    //   },
    //   [
    //     // {'id': 2, 'x': 0, 'y': 0},
    //     // {'id': 2, 'x': 15, 'y': 15},
    //   ]
    // ];

    left = double.parse(foundationData[0]['x'].toString());
    top = double.parse(foundationData[0]['y'].toString());
    width = double.parse(foundationData[0]['w'].toString());
    height = double.parse(foundationData[0]['h'].toString());

    foundationData[1].forEach((data) {
      var x = double.parse(data['x'].toString());
      var y = double.parse(data['y'].toString());
      var imgId = int.parse(data['id'].toString());

      var wall = Wall(x, y, imgId);
      wallList.add(wall);
      _map.addEntity(wall);
    });

    bounds = getBuildingArea();
  }

  void addWall(double x, double y, int imgId) {
    if (isInsideFoundation(x, y)) {
      var wall = Wall(x, y, imgId);

      var foundWall = wallList.firstWhere((element) => element.id == wall.id,
          orElse: () => null);

      if (foundWall == null) {
        wallList.add(wall);
        _map.addEntity(wall);
      }
    }
  }

  void drawArea(Canvas c) {
    bounds = getBuildingArea();

    p.color = Color.fromRGBO(55, 59, 150, .2);
    c.drawRect(bounds, p);

    _txt10.render(c, 'Building area', Position(bounds.left, bounds.top));
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

  bool isInsideFoundation(double x, double y) {
    return x >= left && x < (left + width) && y >= top && y < (top + height);
  }
}
