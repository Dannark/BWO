import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../effects/foam_water_effect.dart';
import '../effects/water_stars_effect.dart';
import '../scene/game_scene.dart';
import '../utils/preload_assets.dart';
import '../utils/vector3.dart';
import 'map_controller.dart';
import 'tile.dart';

class Ground extends Tile {
  WaterStarsEffect waterStarsEffect;
  FoamWaterEffect foamWaterEffect;
  Sprite grass;
  static Paint vpaint = Paint();

  static const water = 95;
  static const lowWater = 110;
  static const lowSand = 112;
  static const sand = 118;
  static const lowGrass = 140;

  Ground(int posX, int posY, MapController map,
          int height, int size, Color color)
      : super(posX, posY, map, height, size, color) {
    var tileColor = getTileDetailsBasedOnHight(this.height);
    color = color != null ? color : tileColor;

    // max zoom level for overview map uses vertices instead of squares
    if (posY % 2 == 0 && posX%map.stripLength == 0){  // size == 1 &&
      makeVertices();
    }
    boxPaint.color = color;

    if (height < lowWater-3 && size >= 8) {
      waterStarsEffect = WaterStarsEffect(boxRect);
    }
    if (height >= lowWater-2 && height <= lowWater && size >= 8) {
      foamWaterEffect = FoamWaterEffect();
    }
  }

  void update () {
    // light source shading for land tiles
    if (shade == 0 && height >= sand) {
      color = adjustLighting(boxPaint.color);
      boxPaint.color = color;
    } else if (height < sand) {
      shade = 1;
    }
    if (posY % 2 == 0 && posX%map.stripLength == 0){  // size == 1 &&
      makeVertices();
    }
  }
  void draw(Canvas c) {
    if (size != GameScene.tilePixels) {
      size = GameScene.tilePixels;
      if (size > 1) {
        // change size of drawn box
        boxRect = Rect.fromLTWH(
          posX.toDouble() * size.toDouble(),
          posY.toDouble() * size.toDouble(),
          size.toDouble() + 1,
          size.toDouble() + 1,
        );
      }
    }
    var scale = GameScene.pixelsPerTile/16;
    if (height >= lowWater-2 && height <= lowWater && size >= 8) {
      foamWaterEffect = foamWaterEffect ?? FoamWaterEffect();
      boxPaint.color =
          foamWaterEffect.getFoamColor(height, posX, posY); //Colors.blue[200];
    }
    if (size == 1 && shade != 0 && ((posX%64) != 0 || (posY%2) != 0)) {
      return; // no need to draw each tile, only
    }

    // normal map zooms draw boxes
    if (size > 1) {
      c.drawRect(boxRect, boxPaint);
    }
    // max zoom draws vertices
    else {
      if (vertices != null) {
        c.drawVertices(vertices, BlendMode.src, vpaint);
      }
    }

    if (grass != null && size >= 8) {
      grass.renderScaled(c, Position(boxRect.left, boxRect.top), scale: scale);
    }

    if (height < lowWater-3 && size >= 8) {
      waterStarsEffect = waterStarsEffect ?? WaterStarsEffect(boxRect);
      waterStarsEffect.blinkWaterEffect(c);
    }
  }

  Color getTileDetailsBasedOnHight(int heightLvl) {
    height = heightLvl;
    //int green = 255 - heightLvl;
    var green = (155 - (heightLvl-100)/2).toInt();

    if (heightLvl > 142 && heightLvl < 152 && Random().nextInt(100) > 98) {
      var id = Random().nextInt(5) + 1;
      grass = PreloadAssets.getEnviromentSprite("floor$id");
      /*grass = Sprite("enviroment/floor${id}.png",
          width: size.toDouble(), height: size.toDouble());*/
    }

    if (heightLvl < 20) { // < 50
      return Colors.blue[700];
    } else if (heightLvl < 40) { // < 75
      return Colors.blue[600];
    } else if (heightLvl < water) {
      return Colors.blue;
    } else if (heightLvl < lowWater) {
      return Colors.blue[400];
    } else if (heightLvl < lowSand) {
      return Color.fromRGBO(255, 224, 130, .94);
    } else if (heightLvl < sand) {
      return Colors.amber[200];
    } else if (heightLvl < lowGrass) {
      if (Random().nextInt(100) > 95) {
        var id = Random().nextInt(4) + 7;
        grass = PreloadAssets.getEnviromentSprite("grass$id");
        /*grass = Sprite("enviroment/grass$id.png",
            width: size.toDouble(), height: size.toDouble());*/
      }
      return Color.fromRGBO(116, green + 50, 54, 1);
    } else if (heightLvl < 160) {
      if (Random().nextInt(100) > 96) {
        var id = Random().nextInt(2) + 11;
        grass = PreloadAssets.getEnviromentSprite("grass$id");
        /*grass = Sprite("enviroment/grass$id.png",
            width: size.toDouble(), height: size.toDouble());*/
      }
      return Color.fromRGBO(82, green + 40, 46, 1);
    } else if (heightLvl < 185) {
      if (Random().nextInt(100) > 98) {
        var id = Random().nextInt(2) + 13;
        grass = PreloadAssets.getEnviromentSprite("grass$id");
        /*grass = Sprite("enviroment/grass${id}.png",
            width: size.toDouble(), height: size.toDouble());*/
      }
      return Color.fromRGBO(75, green + 36, 65, 1);
    } else if (heightLvl < 190) {
      return Color.fromRGBO(82, green+28, 46, 1); // was ugly brown color
    } else {
      return Color.fromRGBO(  // gray color for peaks
          heightLvl - 60, heightLvl - 60, heightLvl - 60, 1);
    }
  }

  final int imageSize =8;
  bool b = false;
  void makeVertices() async {
    b = true;
    Tile tile;
    int i,j;
    var positions =<Offset>[];
    var colors=<Color>[];
    if (map.map[posY-2] == null || map.map[posY] == null) {
      return;
    }
    for (i=-map.stripLength-2; i<=0; i+=2){
      for (j=-2; j<=0; j+=2){
        if (map.map[posY+j][posX+i] != null) {
          tile = map.map[posY + j][posX + i][0];
          if (tile?.boxPaint?.color != null && tile?.shade != 0) {
             positions.add(Offset(posX+i.toDouble(), posY+j.toDouble()));
            colors.add(tile.boxPaint.color);
          }
        }
      }
    }
    if (positions.length >= map.stripLength) {
      vertices = ui.Vertices(VertexMode.triangleStrip,positions,colors:colors);
    }
  }

  /// cross some vectors to make the terrain look a bit more 3D
  Color adjustLighting (Color color) {
    var heightLeft = height;
    var heightTop = height;
    var heightMid = height;
    var lightV = Vector3(0.5,0,1).normalized();
    if (map.map[posY-1] == null || map.map[posY-1][posX] == null) {
      if (map.map[posY+1] != null && map.map[posY+1][posX] != null) {
        heightMid = map.map[posY+1][posX][0].height;
      } else{
        return color;  // it will hit this pixel later
      }
    } else {
      heightTop = map.map[posY - 1][posX][0].height;
    }

    if (map.map[posY][posX-1] == null || map.map[posY][posX-1] == null) {
      if (map.map[posY] != null && map.map[posY][posX+1] != null) {
        heightMid = map.map[posY][posX+1][0].height;
      } else {
        return color; // it will hit this pixel later
//        if (map.map[posY+1] != null && map.map[posY+1][posX] != null) {
//          heightMid = map.map[posY+1][posX][0].height;
//        } else {
//          return color; // it will hit this pixel later
//        }
      }
    } else {
      heightLeft = map.map[posY][posX-1][0].height;
    }
    if (heightLeft == 0 && heightTop == 0) {
      return color;
    }

    var west = Vector3(8, 0, (heightLeft-heightMid).toDouble());
    var north = Vector3(0, 8, (heightTop-heightMid).toDouble());
    var normal = west.cross(north);
    normal.normalize();
    //print ('normal: ${normal.x},${normal.y},${normal.z}');
    shade = lightV.dot(normal)/2 + 0.5;
    return Color.fromARGB(color.alpha, (color.red*shade).toInt(),
        (color.green*shade).toInt(), (color.blue*shade).toInt());
  }
}
