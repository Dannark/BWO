import 'package:BWO/Entity/Enemys/Enemy.dart';
import 'package:BWO/Map/map_controller.dart';
import 'package:flutter/material.dart';

class Skull extends Enemy {
  Skull(double x, double y, MapController map, String name, String id)
      : super(x, y, map, "enemys/miniskull", id) {
    iaController.walkSpeed = 1;
    super.name = name;
    status.setLevel(2, .5);
  }
}
