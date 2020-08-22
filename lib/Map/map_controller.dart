import 'dart:ui' as ui;

import 'package:fast_noise/fast_noise.dart';
import 'package:flutter/material.dart';

import '../entity/entity.dart';
import '../entity/player/player.dart';
import '../game_controller.dart';
import 'ground.dart';
import 'tile.dart';
import 'tree.dart';

class MapController {
  final Map<int, Map<int, Map<int, Tile>>> map = {};
  Player player;

  double widthViewPort;
  double heightViewPort;

  double posX = 0;
  double posY = 0;
  Offset targetPos;

  List<Entity> entityList = [];
  List<Entity> entitysOnViewport = [];
  List<Entity> _tmpEntitysToBeAdded = [];
  int treesGenerated = 0;
  int tilesGenerated = 0;

  int safeY = 0;
  int safeYmax = 0;
  int safeX = 0;
  int safeXmax = 0;

  double cameraSpeed = 5;

  int _loopsPerCycle = 0;
  int _maxLoopsPerCycle = 200; //first loop

  SimplexNoise terrainNoise = SimplexNoise(
    frequency: 0.003, //0.004
    gain: 1,
    lacunarity: 2.6,
    octaves: 3,
    fractalType: FractalType.FBM,
  );

  PerlinNoise terrainNoise2 = PerlinNoise(
    frequency: .005,
    gain: 1,
    lacunarity: 1,
    octaves: 1,
    fractalType: FractalType.FBM,
  );
  PerlinNoise treeNoise = PerlinNoise(
    frequency: .8,
    gain: 1,
    lacunarity: 1,
    octaves: 1,
    fractalType: FractalType.FBM,
  );

  MapController(Offset startPosition) {
    posX = startPosition.dx;
    posY = startPosition.dy;
    targetPos = Offset(posX, posY);
  }

  void drawMap(Canvas c, double moveX, double moveY, Rect screenSize,
      {int tileSize = 15,
      int border = 6,
      int movimentType = MovimentType.move}) {
    var borderSize = (border * tileSize);

    widthViewPort =
        (screenSize.width / tileSize).roundToDouble() + (border * 2);
    heightViewPort =
        (screenSize.height / tileSize).roundToDouble() + (border * 2);

    // move camera
    if (movimentType == MovimentType.move) {
      posX += moveX.roundToDouble();
      posY += moveY.roundToDouble();
    } else if (movimentType == MovimentType.follow) {
      targetPos = Offset(
          (-moveX.roundToDouble() + screenSize.width / 2) + border * tileSize,
          (-moveY.roundToDouble() + screenSize.height / 2) + border * tileSize);

      posX = ui
          .lerpDouble(
              posX, targetPos.dx, GameController.deltaTime * cameraSpeed)
          .roundToDouble();
      posY = ui
          .lerpDouble(
              posY, targetPos.dy, GameController.deltaTime * cameraSpeed)
          .roundToDouble();
    }

    c.save();
    c.translate(posX - borderSize, posY - borderSize);

    var viewPort = Rect.fromLTWH(
      -posX / tileSize,
      -posY / tileSize,
      widthViewPort,
      heightViewPort,
    );

    safeY = (viewPort.top).ceil();
    safeYmax = (viewPort.bottom).ceil() + 6;
    safeX = (viewPort.left).ceil();
    safeXmax = (viewPort.right).ceil();

    for (var y = safeY; y < safeYmax; y++) {
      for (var x = safeX; x < safeXmax; x++) {
        var isSafeLine = map[y] != null ? map[y][x] != null : false;

        if (isSafeLine) {
          //check if tile already exist, if yes, draw, otherwise create it
          var safeZmax = map[y][x].length;
          for (var z = 0; z < safeZmax; z++) {
            map[y][x][z].draw(c);
          }
        } else {
          if (_loopsPerCycle < _maxLoopsPerCycle) {
            var tileHeight =
                ((terrainNoise.getSimplexFractal2(x.toDouble(), y.toDouble()) *
                            128) +
                        127)
                    .toInt();

            /*var tileHeight2 =
                ((terrainNoise2.getPerlin2(x.toDouble(), y.toDouble()) * 128) +
                        127)
                    .toInt();
            tileHeight = ((tileHeight + tileHeight2) ~/ 2);*/

            if (map[y] == null) {
              map[y] = {x: null}; //initialize line
            }
            if (map[y][x] == null) {
              map[y][x] = {0: null}; //initialize line
            }
            map[y][x][0] = Ground(x, y, tileHeight, tileSize, null);
            tilesGenerated++;
            _loopsPerCycle++;

            //TREE

            if (tileHeight > 130 && tileHeight < 180) {
              _addTrees(x, y, tileHeight, tileSize);
            }
          }
        }
      }
    }
    _loopsPerCycle = 0;
    _maxLoopsPerCycle = 50;

    // Organize List to show Entity elements (Players, Trees)
    // on correct Y-Index order
    _findEntitysOnViewport();
    entitysOnViewport.sort((a, b) => a.y.compareTo(b.y));

    //drawShadowns behind all elements
    for (var entity in entitysOnViewport) {
      entity.drawEffects(c);
    }
    for (var entity in entitysOnViewport) {
      entity.draw(c);
    }

    c.restore();
  }

  int getHeightOnPos(int x, int y) {
    var defaultHeight = 255;
    if (map[y] != null) {
      if (map[y][x] != null) {
        defaultHeight = map[y][x][0].height;
      }
    }
    return defaultHeight;
  }

  void _addTrees(int x, int y, int z, int tileSize) {
    if (x % 6 == 0 && y % 6 == 0) {
      var treeHeight =
          ((treeNoise.getPerlin2(x.toDouble(), y.toDouble()) * 128) + 127)
              .toInt();

      if (treeHeight > 165) {
        treesGenerated++;

        if (y % 5 == 0) {
          entityList.add(Tree(this, x, y, tileSize, "tree04"));
        } else if (y % 6 == 0) {
          entityList.add(Tree(this, x, y, tileSize, "tree02"));
        } else if (y % 7 == 0) {
          entityList.add(Tree(this, x, y, tileSize, "tree03"));
        } else {
          entityList.add(Tree(this, x, y, tileSize, "tree01"));
        }
      }
    }
  }

  void addEntity(Entity newEntity) {
    var foundEntity = _tmpEntitysToBeAdded.firstWhere(
        (element) => element.id == newEntity.id,
        orElse: () => null);

    if (foundEntity == null) {
      _tmpEntitysToBeAdded.add(newEntity);
    }
  }

  void addPlayerRef(Player player) {
    this.player = player;
    entityList.add(player);
  }

  bool _isEntityInsideViewport(Entity entity) {
    return (entity.posX > safeX &&
        entity.posY > safeY &&
        entity.posX < safeXmax &&
        entity.posY < safeYmax);
  }

  void _findEntitysOnViewport() {
    entitysOnViewport.clear();

    entityList.removeWhere((element) => element.marketToBeRemoved);

    //add entities in queuee
    for (var e in _tmpEntitysToBeAdded) {
      entityList.add(e);
      entitysOnViewport.add(e);
    }
    _tmpEntitysToBeAdded.clear();

    var distance = (Offset(posX, posY) - targetPos).distance;

    for (var i = 0; i < entityList.length; i++) {
      if (entityList[i] is Player || _isEntityInsideViewport(entityList[i])) {
        entitysOnViewport.add(entityList[i]);
      }

      if (_isEntityInsideViewport(entityList[i]) == false &&
          entityList[i] is Player &&
          entityList[i] != player &&
          distance < 16) {
        //entityList.remove(entityList[i]);
        entityList[i].marketToBeRemoved = true;
      }
    }
  }
}

class MovimentType {
  static const int none = 0;
  static const int move = 1;
  static const int follow = 2;
}
