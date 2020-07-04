import 'dart:math';

import 'package:BWO/Entity/Entity.dart';
import 'package:BWO/Entity/Player/Player.dart';
import 'package:BWO/Map/Tile.dart';
import 'package:BWO/Map/map_controller.dart';
import 'package:BWO/Map/tree.dart';
import 'package:flutter/material.dart';

class PhysicsController {
  MapController map;

  PhysicsController(this.map) {}

  void update() {
    calculateCollisions();
  }

  void calculateCollisions() {
    var entityList = map.entitysOnViewport;
    entityList.forEach((e1) {
      if (e1 is Player) {
        e1.updatePhysics();

        entityList.forEach((e2) {
          if (e1 != e2 && e2.isActive && e1.isActive) {
            int maxAmountOfTimesToPushPlayerOutPerLoop = 10;
            while (maxAmountOfTimesToPushPlayerOutPerLoop > 0) {
              Rectangle r1 = Rectangle(
                  e1.collisionBox.left,
                  e1.collisionBox.top,
                  e1.collisionBox.width,
                  e1.collisionBox.height);
              Rectangle r2 = Rectangle(
                  e2.collisionBox.left,
                  e2.collisionBox.top,
                  e2.collisionBox.width,
                  e2.collisionBox.height);

              if (r1.intersects(r2)) {
                if (e2.isCollisionTrigger == false) {
                  var direction = (Offset(e1.x, e1.y) - Offset(e2.x, e2.y));
                  e1.x += direction.dx.clamp(-1, 1);
                  e1.y += direction.dy.clamp(-1, 1);
                  e1.updatePhysics();
                } else {
                  e1.onTriggerStay(e2);
                  break;
                }
                //Rectangle intersection = r1.intersection(r2);

                maxAmountOfTimesToPushPlayerOutPerLoop--;
              } else {
                break;
              }
            }
          }
        });
      }

      //blockWalkOnHeightAreas(e1);
    });
  }

  void blockWalkOnHeightAreas(Entity e) {
    if (e.mapHeight > 182) {
      Tile lowestTile;
      for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
          var rowX = map.map[e.posY + y];

          if (rowX != null) {
            var rowZ = map.map[e.posY + y][e.posX + x];

            if (rowZ != null) {
              if (lowestTile == null) {
                lowestTile = rowZ[0];
              } else {
                if (lowestTile.height < rowZ[0].height) {
                  lowestTile = rowZ[0];
                }
              }
            }
          }
        }
      }
      if (lowestTile != null) {
        int maxAmountOfTimesToPushPlayerOutPerLoop = 10;
        while (maxAmountOfTimesToPushPlayerOutPerLoop > 0) {
          var mapHeight = map.map[e.posY][e.posX][0].height;

          if (mapHeight > 182) {
            var direction = (Offset(e.posX.toDouble(), e.posY.toDouble()) -
                Offset(lowestTile.posX.toDouble(), lowestTile.posY.toDouble()));
            e.x += direction.dx.clamp(-1, 1);
            e.y += direction.dy.clamp(-1, 1);
            e.updatePhysics();
            maxAmountOfTimesToPushPlayerOutPerLoop--;
          } else {
            break;
          }
        }
      }
    }
  }
}
