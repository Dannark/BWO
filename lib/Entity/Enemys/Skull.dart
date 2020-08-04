import 'package:BWO/Entity/Enemys/Enemy.dart';
import 'package:BWO/Map/map_controller.dart';
import 'package:flutter/material.dart';

class Skull extends Enemy {
  Skull(double x, double y, MapController map, String name, String id,
      {Offset moveTo = Offset.zero})
      : super(x, y, map, "enemys/miniskull", id) {
    iaController.walkSpeed = 1;

    moveTo != Offset.zero ? iaController.moveTo(moveTo.dx, moveTo.dy) : null;

    super.name = name;
    status.setLevel(2, .5);
  }
}
