import 'package:flutter/material.dart';

import '../../ui/hud.dart';
import '../../ui/ui_element.dart';
import '../../utils/tap_state.dart';
import 'player.dart';

class JoystickUI extends UIElement {
  final Player _player;
  Offset _input = Offset.zero;

  double maxSpeedRadius = 3;

  final Paint _p = Paint();

  bool isEnable = true;

  JoystickUI(this._player, HUD hudRef) : super(hudRef) {
    drawOnHUD = true;
  }

  void update(double dt, {bool isEnable = true}) {
    this.isEnable = isEnable;
    _player.xSpeed = 0;
    _player.ySpeed = 0;

    if (TapState.isTapingRight() && isEnable) {
      var diff = (TapState.pressedPosition - TapState.currentPosition) * 0.1;
      _input = diff;

      if (diff.distance > maxSpeedRadius) {
        _input *= maxSpeedRadius / diff.distance;
      }
      if (_input.distance > 0.6) {
        _player.xSpeed = _input.dx;
        _player.ySpeed = _input.dy;
      }
    }
  }

  @override
  void draw(Canvas c) {
    if (TapState.isTapingRight() && isEnable) {
      _p.color = Color.fromRGBO(0, 0, 0, .25);
      _p.strokeWidth = 0;
      _p.style = PaintingStyle.fill;
      c.drawCircle(TapState.pressedPosition, 32, _p);

      _p.strokeWidth = 3;
      _p.style = PaintingStyle.stroke;
      c.drawCircle(TapState.pressedPosition, 38, _p);

      _p.color = Color.fromRGBO(0, 0, 0, .25);
      _p.style = PaintingStyle.fill;
      _p.strokeWidth = 0;
      c.drawCircle(TapState.pressedPosition - (_input * 10), 16, _p);
    }
  }
}
