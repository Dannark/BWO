import 'package:flutter/material.dart';

import '../Entity.dart';
import 'enemy.dart';

abstract class IAController {
  Enemy self;
  Entity target;

  IAController(this.self);

  double walkSpeed = .5;

  void update() {}

  void patrolArea() {}

  void moveTo(double targetX, double targetY) {}

  Offset getDestination() {
    return Offset.zero;
  }

  void searchForTargetsEntity() {}

  void attackTarget(Entity target, {int damage = 0, int targetHp = 0}) {}
}
