import 'dart:ui';

import 'package:BWO/Entity/Player/Player.dart';
import 'package:BWO/game_controller.dart';

class PlayerNetwork {
  Player player;
  double lerpSpeed = 1.9;

  int lastX = 0;
  int lastY = 0;

  double newX = 0;
  double newY = 0;

  double _nextSendUpdate = 0;
  double updateFrequency = 0.25;

  int amountOfMsgSent = 0;
  PlayerNetwork(this.player) {
    lastX = player.posX;
    lastY = player.posY;
    newX = player.posX.toDouble();
    newY = player.posY.toDouble();
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
        amountOfMsgSent++;
        print(amountOfMsgSent);
        GameController.serverController.movePlayer();
      }
    }
  }

  void _moveLerpPosition() {
    var targetPos = Offset(newX.toDouble(), newY.toDouble());

    var distance = (Offset(player.x, player.y) - targetPos).distance;
    if (distance > 250) {
      player.x = targetPos.dx;
      player.y = targetPos.dy;
    }
    player.xSpeed =
        lerpDouble(player.xSpeed, 0, GameController.deltaTime * lerpSpeed);
    player.ySpeed =
        lerpDouble(player.ySpeed, 0, GameController.deltaTime * lerpSpeed);

    player.x = lerpDouble(
        player.x, newX - player.xSpeed, GameController.deltaTime * lerpSpeed);
    player.y = lerpDouble(
        player.y, newY - player.ySpeed, GameController.deltaTime * lerpSpeed);
    player.setDirection(targetPos);
  }

  void setTargetPosition(double newX, double newY) {
    this.newX = newX;
    this.newY = newY;
  }

  void controllAnimation() {}
}
