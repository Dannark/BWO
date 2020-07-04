import 'package:BWO/Entity/Enemys/Enemy.dart';
import 'package:BWO/Map/map_controller.dart';
import 'package:flutter/material.dart';

class Skull extends Enemy {
  Skull(double x, double y, MapController map)
      : super(x, y, map, "enemys/miniskull") {
    iaController.walkSpeed = 1;
    status.setLife(10);
  }
}
