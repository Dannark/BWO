import 'package:BWO/Entity/Enemys/Enemy.dart';
import 'package:BWO/Entity/Entity.dart';
import 'package:flutter/material.dart';

abstract class IAController {
  Enemy self;
  Entity target;

  IAController(this.self);

  double walkSpeed = .5;

  void update() {}

  patrolArea() {}

  void moveTo(double targetX, double targetY) {}

  Offset getDestination() {
    return Offset.zero;
  }

  void searchForTargetsEntity() {}

  void attackTarget(Entity target, {int damage = 0}) {}
}
