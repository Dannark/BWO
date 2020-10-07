import 'dart:ui';

import 'package:flame/flame.dart';

import '../../game_controller.dart';
import '../../scene/game_scene.dart';
import 'player.dart';

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
      print('teleporting player ${player.name} because he is too far');
      player.x = targetPos.dx;
      player.y = targetPos.dy;
    } else {
      if (distance > 8) {
        player.setDirection(targetPos);
        player.x = lerpDouble(
            player.x, targetPos.dx, GameController.deltaTime * lerpSpeed);
        player.y = lerpDouble(
            player.y, targetPos.dy, GameController.deltaTime * lerpSpeed);
      }
    }
  }

  void setTargetPosition(double newX, double newY) {
    this.newX = newX;
    this.newY = newY;
  }

  void sendHitTree(int x, int y, int damage) {
    var jsonData = {
      "name": "${player.name}",
      "x": x,
      "y": y,
      "damage": damage,
    };
    GameScene.serverController.sendMessage("onTreeHit", jsonData);
  }

  /// Attack Enemy Entity, the damage is not calculated on the server-side.
  void attackEnemy(String enemyId, int damage) {
    Flame.audio.play('punch.mp3', volume: 0.4);
    var jsonData = {"enemyId": enemyId, "damage": damage};
    GameScene.serverController.sendMessage("onPlayerAttackEnemy", jsonData);
  }

  void hitTreeAnimation(double targetX, double targetY) {
    player.currentSprite = player.attackSprites;
    Flame.audio.play("punch.mp3", volume: 0.5);
    player.status.consumeHungriness(0.3);

    var targetPos = Offset(targetX, targetY);
    player.setDirection(targetPos);
  }

  void refillStatus() {
    if (player.isMine) {
      var jsonData = {
        "action": "reviving",
        "hp": player.status.getMaxHP(),
        "x": 0,
        "y": 0,
      };
      GameScene.serverController.sendMessage("onUpdate", jsonData);
    }
  }
}
