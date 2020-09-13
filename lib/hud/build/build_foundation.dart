import 'dart:math';

import 'package:BWO/entity/wall/door.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../entity/player/player.dart';
import '../../entity/wall/foundation.dart';
import '../../entity/wall/furniture.dart';
import '../../map/ground.dart';
import '../../map/map_controller.dart';
import '../../map/tree.dart';
import '../../server/utils/server_utils.dart';
import '../../utils/tap_state.dart';
import '../../utils/timer_helper.dart';
import '../../utils/toast_message.dart';
import 'build_hud.dart';

/*
 * This Class will receive updates from server
 */

class BuildFoundation {
  final Player _player;
  final MapController _map;

  List<Foundation> foundationList = [];
  Foundation myFoundation;

  BuildFoundation(this._player, this._map);

  void createFoundation(dynamic foundationData, Function(bool) callback) {
    var x = double.parse(foundationData['x'].toString());
    var y = double.parse(foundationData['y'].toString());
    var w = double.parse(foundationData['w'].toString());
    var h = double.parse(foundationData['h'].toString());

    var newArea = Rectangle(x, y, w, h);
    var initialArea = Rectangle(-16, -16, 32, 32);

    if (isInsideSpecialArea(newArea, initialArea)) {
      Toast.add("You can't place foundations inside initial area.");
      callback(false);
      return;
    }

    //checks if there are any other too close or inside, if not proceed
    getAllFoundationAround(x.floor(), y.floor(), w.toInt(), h.toInt())
        .then((isAvailable) {
      if (isAvailable.body == 'true') {
        var isValid = checkIfTerrainLocationIsValid(
            x.floor(), y.floor(), w.toInt(), h.toInt());
        if (!isValid) return;

        instantiateFoundation(foundationData);
        callback(true);
      } else {
        Toast.add('This area is now available to place your foundation');
      }
    });
  }

  void drawRoofs(Canvas c) {
    var t = TimerHelper();
    foundationList.forEach((element) {
      element.drawRoof(c);
    });
    t.logDelayPassed("drawRoofs");
  }

  //------------------- VALIDATIONs ------------------------
  bool checkIfTerrainLocationIsValid(int x, int y, int w, int h) {
    var trees = getAmountOfTreesAround(x, y, w, h);

    if (trees.length > 0) {
      Toast.add("This place if blocked by a Tree. You should remove it first.");
      return false;
    }

    if (isAboveWater(x, y, w, h)) {
      Toast.add("You can't place foundations above water");
      return false;
    }

    var newArea = Rectangle(x, y, w, h);
    var initialArea = Rectangle(-16, -16, 32, 32);
    if (isInsideSpecialArea(newArea, initialArea)) {
      Toast.add("You can't place foundations inside initial aera.");
      return false;
    }
    return true;
  }

  Future<http.Response> getAllFoundationAround(int x, int y, int w, int h) {
    print('requesting foundation location avaiablity');
    return http.get('${ServerUtils.server}/foundations/at/$x/$y/$w/$h');
  }

  bool isInsideSpecialArea(Rectangle r1, Rectangle r2) {
    return r1.intersects(r2);
  }

  List<dynamic> getAmountOfTreesAround(int left, int top, int w, int h) {
    var treeList = [];
    for (var entity in _map.entitysOnViewport) {
      if (entity is Tree) {
        if (entity.posX >= left &&
            entity.posY >= top &&
            entity.posX <= left + w &&
            entity.posY <= top + h) {
          treeList.add(entity);
        }
      }
    }

    return treeList;
  }

  bool isAboveWater(int left, int top, int w, int h) {
    var right = left + w;
    var bottom = top + h;
    for (var y = top; y < bottom; y++) {
      for (var x = left; x < right; x++) {
        if (_map.map[y][x][0].height < Ground.lowWater) {
          return true;
        }
      }
    }
    return false;
  }

  bool isValidAreaOnFoundation(double x, double y, double w, double h) {
    if (myFoundation == null) return false;

    var isInside =
        myFoundation.isInsideFoundation(x, y, wPoint: w - 1, hPoint: h);
    var isIntersectingWall = _isAreaIntersectingWalls(x, y, w, h);
    var isIntersectingFurniture = _isAreaIntersectingFurnitures(x, y, w, h);

    return isInside && !isIntersectingWall && !isIntersectingFurniture;
  }

  bool _isAreaIntersectingWalls(double x, double y, double w, double h) {
    for (var y1 = y.toInt(); y1 < (y + h); y1++) {
      for (var x1 = x.toInt(); x1 < (x + w); x1++) {
        var id = '_${x1}_${y1 + 1}';
        if (myFoundation.wallList[id] != null) {
          return true;
        }
      }
    }
    return false;
  }

  bool _isAreaIntersectingFurnitures(double x, double y, double w, double h) {
    var isInsideObject = false;

    myFoundation.furnitureList.forEach((key, furniture) {
      var isInside = furniture.isIntersecting(x, y, w, h);
      if (isInside) {
        isInsideObject = true;
      }
    });
    print('isInside $isInsideObject $x $y $w $h');
    return isInsideObject;
  }

  void updateOrInstantiateFoundation(dynamic foundationData) {
    var foundationExists = checkIfFoundationExists(foundationData);

    if (foundationExists != null) {
      //do not update self foundation while in build mode
      if (foundationExists == myFoundation &&
          BuildHUD.buildBtState != BuildButtonState.build) {
        updateBounds(foundationExists, foundationData);
        replaceWalls(foundationExists, foundationData['walls']);
        replaceFloors(foundationExists, foundationData['floors']);
        replaceFurniture(foundationExists, foundationData['furnitures']);
      } else {
        print("ignoring self foundation Update while in building mode");
      }
    } else {
      instantiateFoundation(foundationData);
    }
  }

  void instantiateFoundation(dynamic foundationData) {
    var t = TimerHelper();
    var tmpFoundation = Foundation(foundationData, _map, _player);
    if (myFoundation == null) {
      if (foundationData['owner'] == _player.name) {
        myFoundation = tmpFoundation;
      }
    }
    foundationList.add(tmpFoundation);
    replaceWalls(tmpFoundation, foundationData['walls']);
    replaceFloors(tmpFoundation, foundationData['floors']);
    replaceFurniture(tmpFoundation, foundationData['furnitures']);
    t.logDelayPassed('instantiateFoundation:');
  }

  Foundation checkIfFoundationExists(dynamic foundationData) {
    for (var item in foundationList) {
      if (foundationData['owner'] == item.foundationData['owner']) {
        return item;
      }
    }
    return null;
  }

  void updateBounds(Foundation currentFoundation, dynamic newData) {
    if (currentFoundation == null) return;
    var t = TimerHelper();
    var x = currentFoundation.foundationData['x'];
    var y = currentFoundation.foundationData['y'];
    var w = currentFoundation.foundationData['w'];
    var h = currentFoundation.foundationData['h'];
    if (x != newData['x'] ||
        y != newData['y'] ||
        w != newData['w'] ||
        h != newData['h']) {
      currentFoundation.setup(newData);
    }
    t.logDelayPassed('updateBounds:');
  }

  // ------------------ walls -------------------------------
  void placeWall(int selectedWall) {
    if (myFoundation == null) return;
    var tap = TapState.screenToWorldPoint(TapState.currentPosition, _map) / 16;
    var isInsideObject = false;

    myFoundation.furnitureList.forEach((key, furniture) {
      var isInside = furniture.isInside(tap.dx.floor(), tap.dy.floor());
      if (isInside) {
        isInsideObject = true;
      }
    });
    if (isInsideObject == false) {
      myFoundation.addWall(tap.dx, tap.dy, selectedWall);
    }
  }

  void deleteWall() {
    if (myFoundation == null) return;

    var tap = TapState.screenToWorldPoint(TapState.currentPosition, _map) / 16;
    myFoundation.deleteWall(tap.dx, tap.dy);
  }

  void replaceWalls(Foundation currentFoundation, dynamic newWalls) async {
    if (currentFoundation == null) return;
    var t = TimerHelper();

    currentFoundation.wallList.forEach((key, wall) {
      wall.destroy();
    });

    for (var wall in newWalls) {
      var x = wall['x'].toDouble();
      var y = wall['y'].toDouble();
      var id = wall['id'];

      currentFoundation.addWall(x, y, id);
    }
    t.logDelayPassed('replaceWalls:');
  }

  // ------------------ floors -------------------------------
  void placeFloor(int selectedFloor) {
    if (myFoundation == null) return;
    var tap = TapState.screenToWorldPoint(TapState.currentPosition, _map) / 16;
    myFoundation.addFloor(tap.dx, tap.dy, selectedFloor);
  }

  void replaceFloors(Foundation currentFoundation, dynamic newFloors) {
    if (currentFoundation == null) return;
    var t = TimerHelper();

    currentFoundation.tileList.forEach((key, tile) {
      tile = null;
    });

    for (var tile in newFloors) {
      var x = double.parse(tile['x'].toString());
      var y = double.parse(tile['y'].toString());
      var id = int.parse(tile['id'].toString());

      currentFoundation.addFloor(x, y, id);
    }
    t.logDelayPassed('replaceFloors:');
  }

  // ------------------ furniture -------------------------------
  void placeFurniture(Furniture furniture) {
    myFoundation?.addFurniture(furniture);
  }

  void replaceFurniture(Foundation currentFoundation, dynamic newFurnitures) {
    if (currentFoundation == null) return;
    if (newFurnitures == null) return;
    var t = TimerHelper();

    currentFoundation.furnitureList.forEach((key, furniture) {
      furniture.destroy();
    });

    for (var furnitureData in newFurnitures) {
      var x = furnitureData['x'].toDouble();
      var y = furnitureData['y'].toDouble();
      var w = furnitureData['w'].toDouble();
      var h = furnitureData['h'].toDouble();
      var id = furnitureData['id'].toString();

      var furniture;
      if (id.startsWith('door')) {
        furniture = Door(x, y, w, h, id);
      } else {
        furniture = Furniture(x, y, w, h, id);
      }

      currentFoundation.addFurniture(furniture);
    }

    t.logDelayPassed('replaceFurnitures:');
  }

  void deleteFurniture() {
    if (myFoundation == null) return;

    var tap = TapState.screenToWorldPoint(TapState.currentPosition, _map) / 16;
    myFoundation.deleteFurniture(tap.dx, tap.dy);
  }
}
