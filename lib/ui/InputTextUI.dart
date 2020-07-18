import 'dart:ui';

import 'package:BWO/Utils/TapState.dart';
import 'package:BWO/game_controller.dart';
import 'package:BWO/ui/HUD.dart';
import 'package:BWO/ui/Keyboard/KeyUIListener.dart';
import 'package:BWO/ui/Keyboard/KeyboardUI.dart';
import 'package:BWO/ui/UIElement.dart';
import 'package:flame/anchor.dart';
import 'package:flame/components/text_box_component.dart';
import 'package:flame/components/text_component.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class InputTextUI extends UIElement implements KeyUIListener {
  Position pos;
  String _inputText = "";
  String placeHolder = "Text Example";
  int maxLength = 16;

  double width = 200;
  double height = 40;

  double padding = 8;

  Paint p = Paint();

  var onConfirmCallback;
  var onPressedCallback;

  TextConfig normalText;
  TextConfig placeHolderText;

  double rotation = 0;

  InputTextUI(HUD hudRef, this.pos, this.placeHolder,
      {maxLength: 16,
      Color backGroundColor,
      Color normalColor,
      Color placeholderColor,
      double fontSize = 18.0,
      double rotation = 0})
      : super(hudRef) {
    this.maxLength = maxLength;

    p.color = backGroundColor != null ? backGroundColor : Colors.blueGrey[50];

    normalText = TextConfig(
      fontSize: fontSize,
      color: normalColor != null ? normalColor : Colors.grey[800],
      fontFamily: "Blocktopia",
    );

    placeHolderText = TextConfig(
      fontSize: fontSize,
      color: placeholderColor != null ? placeholderColor : Colors.grey[600],
      fontFamily: "Blocktopia",
    );

    this.rotation = rotation;
  }

  void draw(Canvas c) {
    c.save();
    c.rotate(rotation);
    bounds =
        Rect.fromLTWH(pos.x - width / 2, pos.y - height / 2, width, height);
    c.drawRRect(RRect.fromRectAndRadius(bounds, Radius.circular(5)), p);

    var textOffsetX = ((width - padding - getTextWidth(_inputText)) * -1)
        .clamp(0, double.infinity);

    c.clipRect(bounds);

    if (_inputText.length == 0) {
      placeHolderText.render(
        c,
        placeHolder,
        Position(bounds.left + padding, bounds.center.dy),
        anchor: Anchor.centerLeft,
      );
    } else {
      normalText.render(
        c,
        _inputText,
        Position(bounds.left + padding - textOffsetX, bounds.center.dy),
        anchor: Anchor.centerLeft,
      );
    }

    if (TapState.clickedAtButton(this)) {
      KeyboardUI.openKeyboard(this);
    }
    c.restore();
  }

  double getTextWidth(String text) {
    final constraints = BoxConstraints(
      maxWidth: 800.0, // maxwidth calculated
      minHeight: 0.0,
      minWidth: 0.0,
    );

    RenderParagraph renderParagraph = RenderParagraph(
      TextSpan(
        text: _inputText,
        style: TextStyle(fontSize: 18, fontFamily: 'Blocktopia'),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    renderParagraph.layout(constraints);
    double textlen = renderParagraph.getMinIntrinsicWidth(18).ceilToDouble();

    return textlen;
  }

  String getText() {
    return _inputText;
  }

  @override
  void onConfirmPressed() {
    if (onConfirmCallback != null) onConfirmCallback(_inputText);
  }

  @override
  void onKeyPressed(String keyName) {
    if (_inputText.length < maxLength) {
      _inputText += keyName;
    }

    if (onPressedCallback != null) onPressedCallback(_inputText);
  }

  @override
  void onBackspacePressed() {
    if (_inputText.length > 0) {
      _inputText = _inputText.substring(0, _inputText.length - 1);
    }
  }

  // CALL BACKS
  void onPressedListener({Function(String) callback}) {
    this.onPressedCallback = callback;
  }

  void onConfirmListener({Function(String) callback}) {
    this.onConfirmCallback = callback;
  }
}
