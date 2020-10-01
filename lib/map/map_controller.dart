import 'dart:math';
import 'dart:ui' as ui;

import 'package:fast_noise/fast_noise.dart';
import 'package:flutter/material.dart';

import '../entity/entity.dart';
import '../entity/player/player.dart';
import '../game_controller.dart';
import '../hud/build/build_foundation.dart';
import '../scene/game_scene.dart';
import '../utils/timer_helper.dart';
import 'ground.dart';
import 'tile.dart';
import 'tree.dart';

class MapController {
  final Map<int, Map<int, Map<int, Tile>>> map = {};
  Player player;

  double widthViewPort;
  double heightViewPort;

  int border = 6;

  double posX = 0;
  double posY = 0;
  Offset targetPos;

  List<Entity> entityList = [];
  List<Entity> entitysOnViewport = [];
  final List<Entity> _tmpEntitysToBeAdded = [];
  int treesGenerated = 0;
  int tilesGenerated = 0;

  int safeY = 0;
  int safeYmax = 0;
  int safeX = 0;
  int safeXmax = 0;

  double cameraSpeed = 5;
  BuildFoundation buildFoundation;
  double tilePix;
  double scale;
  int zoom = 2;
  int stripLength = 64;
  GameScene gameScene;

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

  MapController(Offset startPosition, this.gameScene) {
    posX = startPosition.dx;
    posY = startPosition.dy;
    targetPos = Offset(posX, posY);
  }

  void drawMap(Canvas c, double moveX, double moveY, Rect screenSize,
      {int tileSize = 16, int movimentType = MovimentType.move}) {
    var borderSize = (border * tileSize);
    scale = tileSize/16;
    tilePix = tileSize.toDouble();
    // account for 64px wide triangle strips in map overview zoom level
    var strip = tileSize > 1 ? 0 : stripLength;
    widthViewPort =
        (screenSize.width / tileSize).roundToDouble() + (border * 2) + strip;
    heightViewPort =
        (screenSize.height / tileSize).roundToDouble() + (border * 2);

    targetPos = Offset(
        (-moveX.roundToDouble() + screenSize.width / 2) + border * tileSize,
        (-moveY.roundToDouble() + screenSize.height / 2) + border * tileSize);
    if ((posY - targetPos.dy).abs() > 50 || (posX - targetPos.dx).abs() > 50) {
      movimentType = MovimentType.move; // keeps camera centered after zooms
    }
    // move camera
    if (movimentType == MovimentType.move) {
      posX = targetPos.dx;
      posY = targetPos.dy;
    } else if (movimentType == MovimentType.follow) {
      double delta = min (GameController.deltaTime, 0.05);
      posX = ui
          .lerpDouble(
              posX, targetPos.dx, delta * cameraSpeed)
          .roundToDouble();
      posY = ui
          .lerpDouble(
              posY, targetPos.dy, delta * cameraSpeed)
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

    var t = TimerHelper();
    var x,y,z;
    bool isSafeLine;
    int safeZmax;
    for (y = safeY; y < safeYmax; y++) {
      for (x = safeX; x < safeXmax; x++) {
        if (tileSize == 1 && (y%2 != 0 || x%stripLength != 0)) {
          continue;
        }
        isSafeLine = map[y] != null ?
            (map[y][x] != null) : false;

        if (isSafeLine) {

          //check if tile already exist, if yes, draw, otherwise create it
          safeZmax = map[y][x].length;
          for (z = 0; z < safeZmax; z++) {
            map[y][x][z].draw(c);
          }
        } else {
          // tile creation moved to updateMap
        }
      }
    }
    t.logDelayPassed('draw map:');

    _findEntitysOnViewport();

    var t1 = TimerHelper();
    // Organize List to show Entity elements (Players, Trees)
    // on correct Y-Index order
    entitysOnViewport.sort((a, b) => a.y.compareTo(b.y));
    t1.logDelayPassed('draw effects:');

    var t2 = TimerHelper();
    //drawShadowns behind all elements
    for (var entity in entitysOnViewport) {
      if (!entity.marketToBeRemoved) entity.drawEffects(c);
    }
    t2.logDelayPassed('draw effects:');
    var t3 = TimerHelper();
    for (var entity in entitysOnViewport) {
      if (!entity.marketToBeRemoved) entity.draw(c);
    }
    t3.logDelayPassed('draw entity:');

    buildFoundation.drawRoofs(c);

    c.restore();
  }

  int updateFrames = 0;
  void updateMap(double cx, double cy, Rect screenSize,
      {int tileSize = 16, int movimentType = MovimentType.move}) {
    // tile can be generated on every 4th frame, speeds it up a little
    // especially on min zoom level where it iterates every pixel on screen
    if (updateFrames++ % 4 != 0) {
      return;
    }
    scale = tileSize/16;  // min zoom level has tileSize = 1 pixel per tile

    // account for 64px wide triangle strips in map overview zoom level
    var strip = tileSize > 1 ? 0 : stripLength;
    double widthViewPort =
        (screenSize.width / tileSize).roundToDouble() + (border * 2) + strip*2;
    double heightViewPort =
        (screenSize.height / tileSize).roundToDouble() + (border * 2);

    var pos = Offset(
        (-cx.roundToDouble() + screenSize.width / 2) + border * tileSize,
        (-cy.roundToDouble() + screenSize.height / 2) + border * tileSize);

    var viewPort = Rect.fromLTWH(
      -pos.dx / tileSize,
      -pos.dy / tileSize,
      widthViewPort,
      heightViewPort,
    );

    int safeY = (viewPort.top).ceil();
    int safeYmax = (viewPort.bottom).ceil() + 6;
    int safeX = (viewPort.left).ceil();
    int safeXmax = (viewPort.right).ceil();

    // min zoom level uses triangle strips 2x64px, way faster than rects
    if (tileSize == 1) {
      // start on 2x64 line boundaries
      safeY = ((safeY-1) / 2).floor() * 2;
      safeX = ((safeX-1) / stripLength).floor() * stripLength;
    }
    var updatesPerCycle = 0;
    var maxUpdatesPerCycle = 40000;

    var x,y,z;
    var isSafeLine = true;

    for (y = safeY; y < safeYmax; y ++) {
      // min zoom: quick check if triangle strips are filled
      if (tileSize == 1) {
        var lineStrip = true;
        int startY = (y / 2).ceil() * 2;
        if (map[startY] == null) {
          lineStrip = false;
        } else {
          for (x = safeX+stripLength; x < safeXmax - stripLength;
                                                x += stripLength) {
            if (map[startY][x] == null || map[startY][x][0].vertices == null || map[startY][x][0].shade == 0) {
              if (y > safeY+2) {
                lineStrip = false;
                break;
              }
            }
          }
        }
        if (lineStrip == true) {
          continue;
        } // avoid slow inner loop
      }
      for (x = safeX; x < safeXmax; x ++) {
        isSafeLine = map[y] != null ? (map[y][x] != null) : false;

        // new tile needed
        if (!isSafeLine) {
          if (updatesPerCycle < maxUpdatesPerCycle) {
            var tileHeight =
            ((terrainNoise.getSimplexFractal2(x.toDouble(), y.toDouble()) *
                128) + 127).toInt();

            if (map[y] == null) {
              map[y] = {x: null}; //initialize line
            }
            if (map[y][x] == null) {
              map[y][x] = {0: null}; //initialize line
            }

            map[y][x][0] = Ground(x, y, this, tileHeight, tileSize, null);
            tilesGenerated++;
            updatesPerCycle++;

            //TREE
            if (tileHeight > 130 && tileHeight < 180) {
              _addTrees(x, y, tileHeight, 16); // tileSize);
            }
          }
        } else {
          map[y][x][0].update();
        }
      }
    }
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

        if (treeHeight % 5 == 0) {
          entityList.add(Tree(this, x, y, tileSize, "tree_4"));
        } else if (treeHeight % 6 == 0) {
          entityList.add(Tree(this, x, y, tileSize, "tree_3"));
        } else if (treeHeight % 7 == 0) {
          entityList.add(Tree(this, x, y, tileSize, "tree_2"));
        } else {
          entityList.add(Tree(this, x, y, tileSize, "tree_1"));
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
    var t = TimerHelper();
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
    t.logDelayPassed('_findEntitysOnViewport:');
  }

  /// Zoom levels change the pixels per tile used for the draw() functions
  /// (but world units per tile stays as 16 units/tile)
  void setZoom (int zoom) {
    gameScene.setZoom(zoom);
  }

}

class MovimentType {
  static const int none = 0;
  static const int move = 1;
  static const int follow = 2;
}
