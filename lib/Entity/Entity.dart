import 'dart:math';

import 'package:BWO/Effects/DamageEffect.dart';
import 'package:BWO/Effects/RippleWaterEffect.dart';
import 'package:BWO/Effects/WalkEffect.dart';
import 'package:BWO/Entity/Items/Items.dart';
import 'package:BWO/Entity/Player/Player.dart';
import 'package:BWO/Entity/Status.dart';
import 'package:BWO/Map/tree.dart';
import 'package:BWO/Scene/GameScene.dart';
import 'package:BWO/game_controller.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import 'PhysicsEntity.dart';

abstract class Entity extends PhysicsEntity {
  Status status = Status();
  bool marketToBeRemoved = false;
  bool isActive = true;

  String name;

  ///tiled position
  int posX;
  int posY;

  var mapHeight = 1;
  double width = 16;
  double height = 16;

  Rect collisionBox;
  bool isCollisionTrigger = false;

  double worldSize;

  Paint p = new Paint();

  double shadownSize = 2;
  Sprite shadownLarge = new Sprite("shadown_large.png");
  RippleWaterEffect _rippleWaterEffect = RippleWaterEffect();
  WalkEffect _walkEffect = WalkEffect();
  DamageEffect _damageEffect = DamageEffect();

  Entity(double x, double y) : super(x, y) {
    worldSize = GameScene.worldSize.toDouble();

    updatePhysics();
  }

  void draw(Canvas c) {
    print("drawning wrongly, this draw method should be overwritten.");
  }

  void update() {}

  void debugDraw(Canvas c) {
    p.color = Colors.red;
    p.strokeWidth = 1;
    p.style = PaintingStyle.stroke;
    c.drawRect(collisionBox, p);
  }

  void drawEffects(Canvas c) {
    if (!isActive) {
      return;
    }
    _drawShadown(c);
    if (this is Player) {
      _rippleWaterEffect.draw(c, x, y, mapHeight);
      _walkEffect.draw(c, x, y, mapHeight, inputSpeed);
    }
    _damageEffect.draw(c, x, y);
  }

  void _drawShadown(Canvas c) {
    var distanceToGround = 1 - (z.abs().clamp(0, 100) / 100);
    Paint p = Paint();
    p.color = Color.fromRGBO(255, 255, 255, distanceToGround);

    var sizeX = 16 * shadownSize / 2;
    var sizeY = (16 - 3) * shadownSize;

    shadownLarge.renderScaled(
      c,
      Position(
        x - sizeX * distanceToGround,
        y - sizeY * distanceToGround,
      ),
      scale: shadownSize * distanceToGround,
      overridePaint: p,
    );
  }

  void updatePhysics() {
    posX = x ~/ worldSize;
    posY = y ~/ worldSize;

    collisionBox = Rect.fromLTWH(x - (width / 2), y - height, width, height);

    updateGravity();
    moveFriction();
  }

  void getHut(int damage) {
    status.takeDamage(damage);
    _damageEffect.addText(damage);
  }

  void onTriggerStay(Entity entity) {}

  void destroy() {
    marketToBeRemoved = true;
  }
}
