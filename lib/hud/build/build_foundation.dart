import 'dart:math';

import '../../entity/player/player.dart';
import '../../entity/wall/foundation.dart';
import '../../map/map_controller.dart';
import '../../scene/game_scene.dart';
import '../../utils/tap_state.dart';

class BuildFoundation {
  final Player _player;
  final MapController _map;

  List<Foundation> foundationList = [];
  Foundation myFoundation;

  BuildFoundation(this._player, this._map);

  bool createFoundationIfDoesntExists(dynamic foundationData) {
    var created = false;
    var x = double.parse(foundationData['x'].toString());
    var y = double.parse(foundationData['y'].toString());
    var w = double.parse(foundationData['w'].toString());
    var h = double.parse(foundationData['h'].toString());

    var newArea = Rectangle(x, y, w, h);
    var initialArea = Rectangle(-16, -16, 32, 32);

    if (isInsideArea(newArea, initialArea)) {
      print("You can't place your foundation in this location.");
      return created;
    }

    //checks if this area is free to be placed

    //instantiate
    instantiateFoundation(foundationData);
    if (myFoundation != null) {
      GameScene.serverController.sendMessage('onFoundationAdd', foundationData);
    }

    return true;
  }

  bool isInsideArea(Rectangle r1, Rectangle r2) {
    return r1.intersects(r2);
  }

  void updateOrInstantiateFoundation(dynamic foundationData) {
    var foundationExists = checkIfFoundationExists(foundationData);

    if (foundationExists != null) {
      replaceWalls(foundationExists, foundationData['walls']);
    } else {
      instantiateFoundation(foundationData);
    }
  }

  void instantiateFoundation(dynamic foundationData) {
    var tmpFoundation = Foundation(foundationData, _map, _player);
    if (myFoundation == null) {
      if (foundationData['owner'] == _player.name) {
        myFoundation = tmpFoundation;
      }
    }
    foundationList.add(tmpFoundation);
    replaceWalls(tmpFoundation, foundationData['walls']);
  }

  void placeWall() {
    if (myFoundation == null) return;
    var selectedWall = 9;
    var tap = TapState.screenToWorldPoint(TapState.currentPosition, _map) / 16;
    myFoundation.addWall(tap.dx, tap.dy, selectedWall);
  }

  void deleteWall() {
    if (myFoundation == null) return;

    var tap = TapState.screenToWorldPoint(TapState.currentPosition, _map) / 16;
    myFoundation.deleteWall(tap.dx, tap.dy);
  }

  Foundation checkIfFoundationExists(dynamic foundationData) {
    for (var item in foundationList) {
      if (foundationData['owner'] == item.foundationData['owner']) {
        return item;
      }
    }
    return null;
  }

  void replaceWalls(Foundation currentFoundation, dynamic newWalls) {
    if (currentFoundation == null) return;

    for (var wall in currentFoundation.wallList) {
      var foundWall = newWalls.firstWhere(
          (element) => (element['x'] == wall.posX && element['y'] == wall.posY),
          orElse: () => null);

      if (foundWall == null) {
        wall.destroy();
      }
    }

    for (var wall in newWalls) {
      var foundWall = currentFoundation.wallList.firstWhere(
          (element) => element.posX == wall['x'] && element.posY == wall['y'],
          orElse: () => null);

      if (foundWall == null) {
        var x = double.parse(wall['x'].toString());
        var y = double.parse(wall['y'].toString());
        var id = int.parse(wall['id'].toString());

        currentFoundation.addWall(x, y, id);
      }
    }
  }
}
