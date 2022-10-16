import 'dart:math';

import 'package:flutter/material.dart';

import '../../game_controller.dart';
import '../entity.dart';
import '../player/player.dart';
import 'enemy.dart';
import 'ia_controller.dart';

/// This class controlls enemy locally (offline mode).
class IALocalController extends IAController {
  double walkSpeed = .5;
  int patrolAreaRange = 300;
  AggressiveLevel agressiveLevel = AggressiveLevel.passive;

  ///when it sees the target at this distance it will immediately attack it
  int seeTargetDistanceMin = 80;

  ///when it sees the target at this distance it will only
  ///attack if it is running
  final int _seeTargetDistanceMax = 224;
  int attackDistance = 40;
  double attackFrequencyInSec = 2;

  double _followingSpeed = 0;
  Offset _destPoint;
  double _newPatrolAreaDelay = 0;
  final double _stopDistance = 24;
  double _attackSpeedDelay = 0;
  final double _loseTargetDistance = 250;

  IALocalController(Enemy self) : super(self) {
    _destPoint = Offset(self.x, self.y);

    if (_destPoint.distance > 500 * 16) {
      agressiveLevel = AggressiveLevel.aggressive;
    }
  }

  void update() {
    if (self.status.isAlive() == false) {
      return;
    }
    patrolArea();
    searchForTargetsEntity();
    moveTo(_destPoint.dx, _destPoint.dy);
    _attackingTarget();
  }

  void patrolArea() {
    if (target != null) {
      return;
    }
    if (GameController.time > _newPatrolAreaDelay) {
      _newPatrolAreaDelay = GameController.time + Random().nextInt(5) + 5;
      _destPoint = Offset(
          self.x + Random().nextInt(patrolAreaRange) - patrolAreaRange / 2,
          self.y + Random().nextInt(patrolAreaRange) - patrolAreaRange / 2);
    }
  }

  void moveTo(double targetX, double targetY) {
    if (self.currentSprite != self.walkSprites) {
      return;
    }

    var distanceX = (self.x - targetX);
    var distanceY = (self.y - targetY);
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

  void searchForTargetsEntity() {
    if (agressiveLevel == AggressiveLevel.passive) {
      return;
    }
    _followingSpeed = target == null ? 0 : 1;
    for (var entity in self.map.entitysOnViewport) {
      if (entity != self &&
          entity.isActive &&
          entity.status.isAlive() &&
          entity is Player) {
        var distance =
            (Offset(self.x, self.y) - Offset(entity.x, entity.y)).distance;

        if (distance < seeTargetDistanceMin) {
          target = entity as Entity;
        }
        var targetSpeed = (entity.xSpeed + entity.ySpeed).abs();

        if (distance < _seeTargetDistanceMax && targetSpeed > 1.5) {
          target = entity as Entity;
        }
      }
    }
    if (target != null) {
      _destPoint = Offset(target.x, target.y);
    }
  }

  void _attackingTarget() {
    if (target == null) {
      return;
    }
    var distanceToTarget =
        (Offset(self.x, self.y) - Offset(target.x, target.y)).distance;

    if (distanceToTarget > _loseTargetDistance ||
        target.status.isAlive() == false) {
      target = null;
      return;
    }

    var totalSpeed = self.xSpeed + self.ySpeed;
    if (GameController.time > _attackSpeedDelay &&
        distanceToTarget < attackDistance &&
        totalSpeed < 1) {
      _attackSpeedDelay = GameController.time + attackFrequencyInSec;

      self.currentSprite
          .setDirection(Offset(target.x, target.y), Offset(self.x, self.y));
      self.currentSprite = self.attackSprites;
      self.currentSprite
          .setDirection(Offset(target.x, target.y), Offset(self.x, self.y));
      target.getHut(self.status.getBaseAttackDamage(), self, isMine: false);
    }
  }
}

enum AggressiveLevel {
  /// Attack only when you attack first
  passive,

  /// Attack you when see
  aggressive,
}
