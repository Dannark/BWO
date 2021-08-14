import 'package:flutter/material.dart';

import '../game_controller.dart';

class FoamWaterEffect {
  Color foamColor;
  Color normalColor;
  Color sandColor;
  Color current;

  int direction = 0;
  double speed = .5;

  double timeInFuture = 0;
  double timeLine = 0;

  FoamWaterEffect() {
    foamColor = Colors.blue[200];
    normalColor = Color.fromRGBO(83, 173, 246, 1);
    sandColor = Color.fromRGBO(231, 200, 140, 1);
    current = foamColor;

    timeInFuture = GameController.time + 2;
  }

  Color getFoamColor(int height, int x, int y) {
    if (GameController.time > timeInFuture && timeLine >= 1) {
      timeInFuture = GameController.time + 3;
      direction++;
      timeLine = 0;
      if (direction > 5) {
        direction = 0;
      }
    }

    timeLine += GameController.deltaTime * speed;
    timeLine = timeLine.clamp(0.0, 1.0);

    if (direction == 0 || direction == 2) {
      current = Color.lerp(normalColor, foamColor, timeLine);
    } else if (direction == 1 || direction == 3) {
      current = Color.lerp(foamColor, normalColor, timeLine);
    } else if (direction == 4) {
      current = Color.lerp(normalColor, sandColor, timeLine);
    } else {
      current = Color.lerp(sandColor, normalColor, timeLine);
    }

    return current;
  }
}
