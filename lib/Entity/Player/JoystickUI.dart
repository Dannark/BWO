import 'package:BWO/Entity/Player/Player.dart';
import 'package:BWO/Utils/TapState.dart';
import 'package:BWO/ui/HUD.dart';
import 'package:BWO/ui/UIElement.dart';
import 'package:flutter/cupertino.dart';

class JoystickUI extends UIElement {
  Player player;
  Offset input = Offset.zero;

  double maxSpeedRadius = 3;

  JoystickUI(this.player, HUD hudRef) : super(hudRef) {
    drawOnHUD = true;
  }

  void update() {
    player.xSpeed = 0;
    player.ySpeed = 0;
    if (TapState.isTapingRight()) {
      var diff = (TapState.pressedPosition - TapState.currentPosition) * 0.1;
      input = diff;

      if (diff.distance > maxSpeedRadius) {
        input *= maxSpeedRadius / diff.distance;
      }
      if (input.distance > 0.6) {
        player.xSpeed = input.dx;
        player.ySpeed = input.dy;
      }
    }
  }

  @override
  void draw(Canvas c) {
    if (TapState.isTapingRight()) {
      Paint p = Paint();
      p.color = Color.fromRGBO(0, 0, 0, .25);
      p.strokeWidth = 0;
      p.style = PaintingStyle.fill;
      c.drawCircle(TapState.pressedPosition, 32, p);

      p.strokeWidth = 3;
      p.style = PaintingStyle.stroke;
      c.drawCircle(TapState.pressedPosition, 38, p);

      p.color = Color.fromRGBO(0, 0, 0, .25);
      p.style = PaintingStyle.fill;
      p.strokeWidth = 0;
      c.drawCircle(TapState.pressedPosition - (input * 10), 16, p);
    }
  }
}
