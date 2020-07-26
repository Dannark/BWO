import 'package:BWO/Entity/Enemys/Enemy.dart';
import 'package:BWO/Map/map_controller.dart';
import 'package:flutter/material.dart';

class Skull extends Enemy {
  Skull(double x, double y, MapController map, String name)
      : super(x, y, map, "enemys/miniskull") {
    iaController.walkSpeed = 1;
    super.name = name;
    status.setLevel(2, .5);
  }
}
