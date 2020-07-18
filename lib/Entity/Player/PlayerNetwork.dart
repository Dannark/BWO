import 'dart:ui';

import 'package:BWO/Entity/Player/Player.dart';
import 'package:BWO/Scene/GameScene.dart';
import 'package:BWO/Utils/SpriteController.dart';
import 'package:BWO/game_controller.dart';
import 'package:flame/flame.dart';

class PlayerNetwork {
  Player player;
  double lerpSpeed = 1.9;

  int lastX = 0;
  int lastY = 0;

  double newX = 0;
  double newY = 0;

  double _nextSendUpdate = 0;
  double updateFrequency = 0.25;

  PlayerNetwork(this.player) {
    lastX = player.posX;
    lastY = player.posY;
  }

  void update() {
    if (!player.isMine) {
      _moveLerpPosition();
    } else {
      _sendPositionToServer();
    }
  }

  void _sendPositionToServer() {
    if (GameController.time > _nextSendUpdate) {
      _nextSendUpdate = GameController.time + updateFrequency;
      if (lastX != player.x.toInt() || lastY != player.y.toInt()) {
        lastX = player.x.toInt();
        lastY = player.y.toInt();
        //SEND POSITION TO SERVER

        GameScene.serverController.movePlayer();
      }
    }
  }

  void _moveLerpPosition() {
    var targetPos = Offset(newX.toDouble(), newY.toDouble());

    var distance = (Offset(player.x, player.y) - targetPos).distance;

    if (newX == 0 && newY == 0) {
      return;
    }

    if (distance > 250) {
      player.x = targetPos.dx;
      player.y = targetPos.dy;
    } else {
      player.x =
          lerpDouble(player.x, newX, GameController.deltaTime * lerpSpeed);
      player.y =
          lerpDouble(player.y, newY, GameController.deltaTime * lerpSpeed);
    }
    player.setDirection(targetPos);
  }

  void setTargetPosition(double newX, double newY) {
    this.newX = newX;
    this.newY = newY;
  }

  void sendHitTree(int targetX, int targetY, int damage) {
    GameScene.serverController.hitTree(targetX, targetY, damage);
  }

  void hitTreeAnimation(double targetX, double targetY) {
    player.currentSprite = player.attackSprites;
    Flame.audio.play("punch.mp3", volume: 0.5);

    var targetPos = Offset(targetX, targetY);
    player.setDirection(targetPos);
  }

  void controllAnimation() {}
}
