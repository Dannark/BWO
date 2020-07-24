import 'package:BWO/Entity/Player/Player.dart';
import 'package:BWO/ui/HUD.dart';
import 'package:BWO/ui/UIElement.dart';
import 'package:flame/anchor.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';

class PlayerHUD extends UIElement {
  Player _player;
  Paint p = Paint();

  TextConfig txt14 =
      TextConfig(fontSize: 14.0, color: Colors.white, fontFamily: "Blocktopia");
  TextConfig txt10 =
      TextConfig(fontSize: 10.0, color: Colors.white, fontFamily: "Blocktopia");

  Sprite _stomach = Sprite("ui/stomach.png");
  Sprite _stomachBack = Sprite("ui/stomach_back.png");

  PlayerHUD(this._player, HUD hudRef) : super(hudRef) {
    drawOnHUD = true;
  }

  void draw(Canvas c) {
    Rect hp = drawBar(
        c,
        Rect.fromLTWH(10, 20, 100, 14),
        Color.fromRGBO(242, 81, 61, 1),
        _player.status.getHP().toDouble(),
        _player.status.getMaxHP().toDouble(),
        "${_player.status.getHP()}",
        txt14);

    Rect energy = drawBar(
        c,
        Rect.fromLTWH(10, 40, 100, 8),
        Color.fromRGBO(229, 184, 46, 1),
        _player.status.getEnergy(),
        _player.status.getMaxEnergy(),
        "${_player.status.getEnergy().toStringAsFixed(1)}",
        txt10);

    Rect xp = drawBar(
        c,
        Rect.fromLTWH(10, 54, 100, 8),
        Color.fromRGBO(198, 204, 194, 1),
        _player.status.getExp().toDouble(),
        _player.status.getMaxExp().toDouble(),
        "${_player.status.getExp().toInt()} / ${_player.status.getMaxExp().toInt()}",
        txt10);

    txt14.render(
      c,
      "Lv. ${_player.status.getLevel()}",
      Position(hp.left, hp.top - 1),
      anchor: Anchor.bottomLeft,
    );

    txt10.render(
        c, "${_player.posX}, ${_player.posY}", Position(hp.right, hp.top - 1),
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
      double maxVal, String textValue, TextConfig txt) {
    Rect bar2 = Rect.fromLTWH(barRect.left + 2, barRect.top - 2,
        barRect.width - 4, barRect.height + 4);

    p.color = Color.fromRGBO(77, 77, 77, 1);
    c.drawRect(barRect, p);
    c.drawRect(bar2, p);

    double bar_lar = (((currentVal * 100 / (maxVal)) / 100) * barRect.width);
    Rect rBar =
        Rect.fromLTWH(barRect.left, barRect.top, bar_lar, barRect.height);
    Rect rBar2 = Rect.fromLTWH(
        barRect.left + 2, barRect.top - 2, bar_lar - 4, barRect.height + 4);

    p.color = barColor;
    c.drawRect(rBar, p);
    if (rBar.width > 3) {
      c.drawRect(rBar2, p);
    }

    txt.render(
      c,
      "${textValue == "-0.0" ? 0 : textValue}",
      Position(barRect.left + 5, barRect.center.dy),
      anchor: Anchor.centerLeft,
    );

    return barRect;
  }

  void drawIcon(Canvas c, Rect r, Sprite back, Sprite front, double currentVal,
      double maxVal) {
    back.renderRect(c, r);

    double bar_height = (((currentVal * 100 / (maxVal)) / 100) * r.height);

    c.save();
    c.clipRect(Rect.fromLTWH(
        r.left, r.top + (r.height - bar_height), r.width, bar_height));
    front.renderRect(c, r);
    c.restore();
  }
}
