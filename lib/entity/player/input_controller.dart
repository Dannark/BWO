import 'package:sensors/sensors.dart';

import '../../utils/tap_state.dart';
import 'joystick_ui.dart';
import 'player.dart';

class InputController {
  Player player;

  double previousY = 0;
  double defaultY = 6.9; //angle standing up

  int accelerationSpeed = 4;
  double maxAngle = 5;
  double speedMultiplier = .6;

  JoystickUI joystick;

  InputController(this.player) {
    //registerAccelerometer();
    joystick = JoystickUI(player, player.sceneObject.hud);
  }

  void update(double dt) {
    if (!player.isMine) {
      return;
    }

    joystick.update(dt, isEnable: player.canWalk);
  }

  void registerAccelerometer() {
    accelerometerEvents.listen((event) {
      if (!player.isMine) {
        return;
      }
      var eventX = event.x;
      var eventY = event.y;
      if (event.z < 0) {
        eventX = eventX * 1;
        eventY = eventY * -1;
      }

      if (TapState.isTapingRight() && TapState.isTapingBottom()) {
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
}
