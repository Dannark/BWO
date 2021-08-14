import 'dart:math';

import 'package:flutter/material.dart';

import '../game_controller.dart';

abstract class PhysicsEntity {
  double x, y, z = 0;

  //the velocity you want to move
  double xSpeed = 0;
  double ySpeed = 0;
  //the current velocity
  Offset velocity = Offset.zero;
  Offset impulse = Offset.zero;
  Offset inputSpeed = Offset.zero;

  double maxSpeedEnergyMultiplier = 1;

  double _gravity = 0.0;
  double _acceleraction = 0.0;

  double bounciness = .1;
  double friction = 3;

  PhysicsEntity(this.x, this.y);

  void moveWithPhysics() {
    velocity = Offset(
          xSpeed * GameController.deltaTime * 50,
          ySpeed * GameController.deltaTime * 50,
        ) *
        maxSpeedEnergyMultiplier;
    x -= velocity.dx;
    y -= velocity.dy;

    inputSpeed = Offset(xSpeed, ySpeed);
  }

  void moveFriction() {
    impulse =
        Offset.lerp(impulse, Offset.zero, GameController.deltaTime * friction);
    x += impulse.dx;
    y += impulse.dy;
  }

  void updateGravity() {
    if (z > 0) {
      _acceleraction += (1 * GameController.deltaTime);
      _gravity += _acceleraction * 1.0;

      if (_gravity > 10) {
        //_gravity max 10m/s err. I mean 10pixels/deltaTime
        _gravity = 10;
      }
      z -= _gravity;
    }

    if (z < 0) {
      z = 0;
      if (_gravity >= 1) {
        z = 1;
        var impulseForce = _gravity / 2;
        var rForceX = (Random().nextDouble() - 0.5) * impulseForce;
        var rForceY = (Random().nextDouble() - 0.5) * impulseForce;
        impulse = Offset(rForceX, rForceY);
      }
      _gravity = -_gravity * bounciness;
      _acceleraction = 0;
    }
  }

  void slowSpeedWhenItSinks(int mapHeight, {double slowSpeedFactor = 0.6}) {
    var sink = ((105 - mapHeight) * 0.2).clamp(0, 4);
    double slowFactor = 1 - ((sink * 0.25) * slowSpeedFactor);

    xSpeed *= slowFactor;
    ySpeed *= slowFactor;
  }
}
