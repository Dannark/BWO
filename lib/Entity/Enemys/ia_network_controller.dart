import 'package:flutter/material.dart';

import '../entity.dart';
import 'enemy.dart';
import 'ia_controller.dart';

/// This class controlls enemy from network (online mode).

class IANetworkController extends IAController {
  int patrolAreaRange = 300;

  /// when this unit see the target at this distance it will immediately
  /// attack it
  int seeTargetDistanceMin = 80;

  /// when this unit see the target at this distance it will attack only
  /// if it is running
  int seeTargetDistanceMax = 224;
  int attackDistance = 40;
  double attackFrequencyInSec = 2;

  final double _followingSpeed = 0;
  Offset _destPoint;
  final double _stopDistance = 24;

  IANetworkController(Enemy self) : super(self) {
    _destPoint = Offset(self.x, self.y);
  }

  void update() {
    if (self.status.isAlive() == false) {
      return;
    }
    //searchForTargetsEntity();
    _moving();
  }

  void moveTo(double targetX, double targetY) {
    _destPoint = Offset(targetX, targetY);
  }

  @override
  Offset getDestination() {
    return _destPoint;
  }

  void _moving() {
    if (self.currentSprite != self.walkSprites) {
      return;
    }

    var distanceX = (self.x - _destPoint.dx);
    var distanceY = (self.y - _destPoint.dy);
    var dirX = distanceX.clamp(-1, 1);
    var dirY = distanceY.clamp(-1, 1);

    self.xSpeed = 0;
    self.ySpeed = 0;

    if (distanceX.abs() > _stopDistance) {
      self.xSpeed = (walkSpeed + _followingSpeed) * dirX;
    }
    if (distanceY.abs() > _stopDistance) {
      self.ySpeed = (walkSpeed + _followingSpeed) * dirY;
    }
  }

  void attackTarget(Entity target, {int damage = 0, int targetHp = 0}) {
    this.target = target;
    if (target != null) {
      _destPoint = Offset(target.x, target.y);

      var distance = (_destPoint - Offset(self.x, self.y)).distance;
      if (distance > 250 && damage > 0) {
        self.x = _destPoint.dx;
        self.y = _destPoint.dy;
      }
    }

    //show damage
    if (damage > 0) {
      self.currentSprite
          .setDirection(Offset(target.x, target.y), Offset(self.x, self.y));
      self.currentSprite = self.attackSprites;
      self.currentSprite
          .setDirection(Offset(target.x, target.y), Offset(self.x, self.y));

      target.getHut(damage, self, isMine: false);
      //target.showDamage(damage, false);
      target.status.setLife(targetHp);
    }
  }
}
