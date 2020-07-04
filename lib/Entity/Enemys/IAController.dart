import 'dart:math';

import 'package:BWO/Entity/Enemys/Enemy.dart';
import 'package:BWO/Entity/Entity.dart';
import 'package:BWO/Entity/Player/Player.dart';
import 'package:BWO/game_controller.dart';
import 'package:flutter/material.dart';

class IAController {
  Enemy self;
  Entity target;

  double walkSpeed = 1;
  int patrolAreaRange = 300;
  int seeTargetDistance = 164;
  int attackDistance = 32;
  double attackSpeed = 1;

  double _followingSpeed = 0;
  Offset _destPoint;
  double _newPatrolAreaDelay = 0;
  double _stopDistance = 24;
  double _attackSpeedDelay = 0;
  double _loseTargetDistance = 500;

  IAController(this.self) {
    _destPoint = Offset(self.x, self.y);
  }

  void update() {
    patrolArea();
    searchForTargetsEntity();
    moveTo(_destPoint.dx, _destPoint.dy);
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
    _followingSpeed = target == null ? 0 : 1;
    for (var entity in self.map.entitysOnViewport) {
      if (entity != self &&
          entity.isActive &&
          entity.status.isAlive() &&
          entity is Player) {
        var distance =
            (Offset(self.x, self.y) - Offset(entity.x, entity.y)).distance;

        if (distance < seeTargetDistance) {
          target = entity;
        }
      }
    }
    if (target != null) {
      _destPoint = Offset(target.x, target.y);
    }
  }

  void attackTarget() {
    if (target == null) {
      return;
    }
    var distanceToTarget =
        (Offset(self.x, self.y) - Offset(target.x, target.y)).distance;

    if (distanceToTarget > _loseTargetDistance) {
      target = null;
      return;
    }

    if (GameController.time > _attackSpeedDelay &&
        distanceToTarget < attackDistance) {
      _attackSpeedDelay = GameController.time + attackSpeed;

      self.currentSprite = self.attackSprites;
      self.currentSprite
          .setDirection(Offset(target.x, target.y), Offset(self.x, self.y));
      self.getHut(self.status.getMaxAttackPoint());
    }
  }
}
