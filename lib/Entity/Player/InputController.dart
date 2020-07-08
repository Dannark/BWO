import 'package:BWO/Entity/Player/Player.dart';
import 'package:BWO/game_controller.dart';
import 'package:sensors/sensors.dart';
import 'package:BWO/Utils/TapState.dart';

class InputController {
  Player player;

  double previousY = 0;
  double defaultY = 6.9; //angle standing up

  int accelerationSpeed = 4;
  double maxAngle = 5;
  double speedMultiplier = .6;

  InputController(this.player) {
    accelerometerEvents.listen((AccelerometerEvent event) {
      if (!player.isMine) {
        return;
      }
      double eventX = event.x;
      double eventY = event.y;
      if (event.z < 0) {
        eventX = eventX * 1;
        eventY = eventY * -1;
      }

      if (TapState.isTapingRight()) {
        player.xSpeed =
            (eventX * accelerationSpeed).clamp(-maxAngle, maxAngle).toDouble() *
                speedMultiplier;
        player.ySpeed = ((eventY - defaultY) * -accelerationSpeed)
                .clamp(-maxAngle, maxAngle)
                .toDouble() *
            speedMultiplier;
      } else {
        previousY = eventY;
        player.xSpeed = 0;
        player.ySpeed = 0;
      }

      if (player.ySpeed.abs() + player.xSpeed.abs() < 0.6 ||
          player.playerActions.isDoingAction) {
        player.xSpeed = 0;
        player.ySpeed = 0;
      }
    });
  }

  void update() {
    if (GameController.tapState == TapState.DOWN) {
      defaultY = previousY;
    }
  }
}
