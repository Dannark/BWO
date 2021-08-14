import 'package:flutter/material.dart';

import '../../map/map_controller.dart';
import 'enemy.dart';

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
