import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../game_controller.dart';

class Toast {
  static final List<ToastMessage> _toastList = [];

  Toast();

  static void draw(Canvas c) {
    if (_toastList == null) return;

    if (_toastList.length > 0) {
      _toastList[0].draw(c);
      if (!_toastList[0].isAlive()) _toastList.removeAt(0);
    }
  }

  static void add(String txt) {
    var msg = _toastList.firstWhere((element) => element.text == txt,
        orElse: () => null);
    if (msg == null) {
      _toastList.add(ToastMessage(txt));
    } else {}
  }
}

class ToastMessage {
  final double speed = 4;
  final double _maxDuration = 4500;
  final double _delayToDelete = 1000;
  DateTime startTime;
  String text;

  Position _currentPos;
  Position _fadeIn;
  Position _fadeOut;

  Color cNow = Color.fromRGBO(62, 44, 40, .2);
  Color cIn = Color.fromRGBO(62, 44, 40, 1);
  Color cOut = Color.fromRGBO(62, 44, 40, .0);

  final Paint _p = Paint();

  ToastMessage(this.text) {
    _currentPos = Position(
      GameController.screenSize.width / 2,
      GameController.screenSize.height * 0.9,
    );
    _fadeIn = Position(
      GameController.screenSize.width / 2,
      GameController.screenSize.height * 0.8,
    );
    _fadeOut = Position(
      GameController.screenSize.width / 2,
      GameController.screenSize.height * 0.9,
    );
  }

  void draw(Canvas c) {
    startTime == null ? startTime = DateTime.now() : null;

    if (isReadyToFadeOut()) {
      _currentPos = Position(
        lerpDouble(_currentPos.x, _fadeOut.x, GameController.deltaTime * speed),
        lerpDouble(_currentPos.y, _fadeOut.y, GameController.deltaTime * speed),
      );
      cNow = Color.lerp(cNow, cOut, GameController.deltaTime * (speed + 3));
    } else {
      _currentPos = Position(
        lerpDouble(_currentPos.x, _fadeIn.x, GameController.deltaTime * speed),
        lerpDouble(_currentPos.y, _fadeIn.y, GameController.deltaTime * speed),
      );
      cNow = Color.lerp(cNow, cIn, GameController.deltaTime * speed);
    }

    var txtWidth = getTextWidth(text) + 10;
    var bounds = Rect.fromLTWH(
      _currentPos.x - (txtWidth / 2),
      _currentPos.y - 16,
      txtWidth,
      16,
    );

    _p.color = Color.fromRGBO(244, 223, 168, cNow.alpha / 255.0);
    c.drawRRect(RRect.fromRectAndRadius(bounds, Radius.circular(5)), _p);

    var _text = TextConfig(
      fontSize: 12.0,
      color: cNow,
      fontFamily: "Blocktopia",
    );
    _text.render(c, text, _currentPos, anchor: Anchor.bottomCenter);
  }

  bool isReadyToFadeOut() {
    return DateTime.now().difference(startTime).inMilliseconds > _maxDuration;
  }

  bool isAlive() {
    return DateTime.now().difference(startTime).inMilliseconds <
        (_maxDuration + _delayToDelete);
  }

  double getTextWidth(String text) {
    final constraints = BoxConstraints(
      maxWidth: 800.0, // maxwidth calculated
      minHeight: 0.0,
      minWidth: 0.0,
    );

    var renderParagraph = RenderParagraph(
      TextSpan(
        text: text,
        style: TextStyle(fontSize: 12, fontFamily: 'Blocktopia'),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    renderParagraph.layout(constraints);
    var textlen = renderParagraph.getMinIntrinsicWidth(18).ceilToDouble();

    return textlen;
  }
}
