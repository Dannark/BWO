import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../entity/player/player.dart';
import '../ui/hud.dart';
import '../ui/ui_element.dart';

/// SHOWS Players stats on HUD.
/// This class is added to a list of UIElements on GameScene
class PlayerHUD extends UIElement {
  final Player _player;
  final Paint _p = Paint();

  final TextPaint _txt14 = TextPaint(
      style: TextStyle(
          fontSize: 14.0, color: Colors.white, fontFamily: "Blocktopia"));
  final TextPaint _txt10 = TextPaint(
      style: TextStyle(
          fontSize: 10.0, color: Colors.white, fontFamily: "Blocktopia"));

  final Sprite _stomach = Sprite("ui/stomach.png");
  final Sprite _stomachBack = Sprite("ui/stomach_back.png");

  PlayerHUD(this._player, HUD hudRef) : super(hudRef) {
    drawOnHUD = true;
  }

  /// This is called automatically from GameScene that extends HUD class,
  /// and should not be called again manually.
  void draw(Canvas c) {
    var hp = drawBar(
        c,
        Rect.fromLTWH(10, 20, 100, 14),
        Color.fromRGBO(242, 81, 61, 1),
        _player.status.getHP().toDouble(),
        _player.status.getMaxHP().toDouble(),
        "${_player.status.getHP().clamp(0, double.infinity)}/${_player.status.getMaxHP()}",
        _txt14);

    //energy
    drawBar(
        c,
        Rect.fromLTWH(10, 40, 100, 8),
        Color.fromRGBO(229, 184, 46, 1),
        _player.status.getEnergy(),
        _player.status.getMaxEnergy(),
        "${_player.status.getEnergy().toStringAsFixed(1)}",
        _txt10);

    var xp = drawBar(
        c,
        Rect.fromLTWH(10, 54, 100, 8),
        Color.fromRGBO(198, 204, 194, 1),
        _player.status.getExp().toDouble(),
        _player.status.getMaxExp().toDouble(),
        "${_player.status.getExp().toInt()} / ${_player.status.getMaxExp().toInt()}",
        _txt10);

    _txt14.render(
      c,
      "Lv. ${_player.status.getLevel()}",
      Vector2(hp.left, hp.top - 1),
      anchor: Anchor.bottomLeft,
    );

    _txt10.render(
        c, "${_player.posX}, ${_player.posY}", Vector2(hp.right, hp.top - 1),
        anchor: Anchor.bottomRight);

    drawIcon(
      c,
      Rect.fromLTWH(10, xp.bottom + 5, 16, 16),
      _stomachBack,
      _stomach,
      _player.status.getCalories(),
      _player.status.getMaxCalories(),
    );
  }

  Rect drawBar(Canvas c, Rect barRect, Color barColor, double currentVal,
      double maxVal, String textValue, TextPaint txt) {
    var bar2 = Rect.fromLTWH(barRect.left + 2, barRect.top - 2,
        barRect.width - 4, barRect.height + 4);

    _p.color = Color.fromRGBO(77, 77, 77, 1);
    c.drawRect(barRect, _p);
    c.drawRect(bar2, _p);

    var barLar = (((currentVal * 100 / (maxVal)) / 100) * barRect.width);
    var rBar = Rect.fromLTWH(barRect.left, barRect.top, barLar, barRect.height);
    var rBar2 = Rect.fromLTWH(
        barRect.left + 2, barRect.top - 2, barLar - 4, barRect.height + 4);

    _p.color = barColor;
    c.drawRect(rBar, _p);
    if (rBar.width > 3) {
      c.drawRect(rBar2, _p);
    }

    txt.render(
      c,
      "${textValue == "-0.0" ? 0.0 : textValue}",
      Vector2(barRect.left + 5, barRect.center.dy),
      anchor: Anchor.centerLeft,
    );

    return barRect;
  }

  void drawIcon(Canvas c, Rect r, Sprite back, Sprite front, double currentVal,
      double maxVal) {
    back.renderRect(c, r);

    var barHeight = (((currentVal * 100 / (maxVal)) / 100) * r.height);

    c.save();
    c.clipRect(Rect.fromLTWH(
        r.left, r.top + (r.height - barHeight), r.width, barHeight));
    front.renderRect(c, r);
    c.restore();
  }
}
