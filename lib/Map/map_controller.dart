import 'dart:math';
import 'dart:ui' as ui;

import 'package:BWO/Entity/Entity.dart';
import 'package:BWO/Entity/Player/Player.dart';
import 'package:BWO/Map/ground.dart';
import 'package:BWO/Map/tree.dart';
import 'package:BWO/game_controller.dart';
import 'package:fast_noise/fast_noise.dart';
import 'package:flutter/material.dart';
import 'package:BWO/Map/Tile.dart';

class MapController {
  final Map<int, Map<int, Map<int, Tile>>> map = {};
  Player player;

  double widthViewPort;
  double heightViewPort;

  double posX = 0;
  double posY = 0;

  List<Entity> entityList = [];
  List<Entity> entitysOnViewport = [];
  int treesGenerated = 0;
  int tilesGenerated = 0;

  int safeY = 0;
  int safeYmax = 0;
  int safeX = 0;
  int safeXmax = 0;

  double cameraSpeed = 5;

  int _loopsPerCycle = 0;

  var terrainNoise = new SimplexNoise(
    frequency: 0.003, //0.004
    gain: 1,
    lacunarity: 2.6,
    octaves: 3,
    fractalType: FractalType.FBM,
  );

  var terrainNoise2 = new PerlinNoise(
    frequency: .005,
    gain: 1,
    lacunarity: 1,
    octaves: 1,
    fractalType: FractalType.FBM,
  );
  var treeNoise = new PerlinNoise(
    frequency: .8,
    gain: 1,
    lacunarity: 1,
    octaves: 1,
    fractalType: FractalType.FBM,
  );

  MapController(Offset startPosition) {
    posX = startPosition.dx;
    posY = startPosition.dy;
  }

  void drawMap(Canvas c, double moveX, double moveY, Rect screenSize,
      {int tileSize = 15, border = 6, int movimentType = MovimentType.MOVE}) {
    var borderSize = (border * tileSize);

    this.widthViewPort =
        (screenSize.width / tileSize).roundToDouble() + (border * 2);
    this.heightViewPort =
        (screenSize.height / tileSize).roundToDouble() + (border * 2);

    // move camera
    if (movimentType == MovimentType.MOVE) {
      this.posX += moveX.roundToDouble();
      this.posY += moveY.roundToDouble();
    } else if (movimentType == MovimentType.FOLLOW) {
      this.posX = ui
          .lerpDouble(
              posX,
              (-moveX.roundToDouble() + screenSize.width / 2) +
                  border * tileSize,
              GameController.deltaTime * cameraSpeed)
          .roundToDouble();
      this.posY = ui
          .lerpDouble(
              posY,
              (-moveY.roundToDouble() + screenSize.height / 2) +
                  border * tileSize,
              GameController.deltaTime * cameraSpeed)
          .roundToDouble();
    }

    c.save();
    c.translate(posX - borderSize, posY - borderSize);

    Rect viewPort = Rect.fromLTWH(
      -posX / tileSize,
      -posY / tileSize,
      widthViewPort,
      heightViewPort,
    );

    safeY = (viewPort.top).ceil();
    safeYmax = (viewPort.bottom).ceil() + 6;
    safeX = (viewPort.left).ceil();
    safeXmax = (viewPort.right).ceil();

    for (int y = safeY; y < safeYmax; y++) {
      for (int x = safeX; x < safeXmax; x++) {
        bool isSafeLine = map[y] != null ? map[y][x] != null : false;

        if (isSafeLine) {
          //check if tile already exist, if yes, draw, otherwise create it
          int safeZmax = map[y][x].length;
          for (int z = 0; z < safeZmax; z++) {
            map[y][x][z].draw(c);
          }
        } else {
          if (_loopsPerCycle < 50) {
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

    //Organize List to show Entity elements (Players, Trees) on correct Y-Index order
    _findEntitysOnViewport();
    entitysOnViewport.sort((a, b) => a.y.compareTo(b.y));

    //drawShadowns
    for (var entity in entitysOnViewport) {
      entity.drawEffects(c);
    }
    for (var entity in entitysOnViewport) {
      entity.draw(c);
    }

    c.restore();
  }

  int getHeightOnPos(int x, int y) {
    int defaultHeight = 255;
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
          entityList.add(Tree(x, y, tileSize, "tree04"));
        } else if (y % 6 == 0) {
          entityList.add(Tree(x, y, tileSize, "tree02"));
        } else if (y % 7 == 0) {
          entityList.add(Tree(x, y, tileSize, "tree03"));
        } else {
          entityList.add(Tree(x, y, tileSize, "tree01"));
        }
      }
    }
  }

  void addEntity(Entity obj) {
    entityList.add(obj);
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

    for (int i = 0; i < entityList.length; i++) {
      if (entityList[i] is Player || _isEntityInsideViewport(entityList[i])) {
        entitysOnViewport.add(entityList[i]);
      }

      if (_isEntityInsideViewport(entityList[i]) == false &&
          entityList[i] is Player &&
          entityList[i] != player) {
        //remove players outside view
        print(
            "removing player ${entityList[i].name} ${entityList[i].x}, ${entityList[i].x} | ${entityList[i].posX}, ${entityList[i].posY}");
        entityList.remove(entityList[i]);
      }
    }
  }
}

class MovimentType {
  static const int None = 0;
  static const int MOVE = 1;
  static const int FOLLOW = 2;
}
