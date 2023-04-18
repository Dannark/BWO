import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../utils/tap_state.dart';
import 'hud.dart';
import 'keyboard/key_ui_listener.dart';
import 'keyboard/keyboard_ui.dart';
import 'ui_element.dart';

class InputTextUI extends UIElement implements KeyUIListener {
  Vector2 pos;
  String _inputText = "";
  String placeHolder = "Text Example";
  int maxLength = 16;

  double width = 200;
  double height = 40;

  double padding = 8;

  Paint p = Paint();

  Function(String) onConfirmListener;
  Function(String) onPressedListener;

  TextPaint normalText;
  TextPaint placeHolderText;

  double rotation = 0;

  InputTextUI(HUD hudRef, this.pos, this.placeHolder,
      {this.maxLength = 16,
      Color backGroundColor,
      Color normalColor,
      Color placeholderColor,
      double fontSize = 18.0,
      this.rotation = 0})
      : super(hudRef) {
    p.color = backGroundColor != null ? backGroundColor : Colors.blueGrey[50];

    normalText = TextPaint(
        style: TextStyle(
      fontSize: fontSize,
      color: normalColor != null ? normalColor : Colors.grey[800],
      fontFamily: "Blocktopia",
    ));

    placeHolderText = TextPaint(
        style: TextStyle(
      fontSize: fontSize,
      color: placeholderColor != null ? placeholderColor : Colors.grey[600],
      fontFamily: "Blocktopia",
    ));
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

    if (_inputText.isEmpty) {
      placeHolderText.render(
        c,
        placeHolder,
        Vector2(bounds.left + padding, bounds.center.dy),
        anchor: Anchor.centerLeft,
      );
    } else {
      normalText.render(
        c,
        _inputText,
        Vector2(bounds.left + padding - textOffsetX, bounds.center.dy),
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

    var renderParagraph = RenderParagraph(
      TextSpan(
        text: _inputText,
        style: TextStyle(fontSize: 18, fontFamily: 'Blocktopia'),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    renderParagraph.layout(constraints);
    var textlen = renderParagraph.getMinIntrinsicWidth(18).ceilToDouble();

    return textlen;
  }

  String getText() {
    return _inputText;
  }

  @override
  void onConfirmPressed() {
    if (onConfirmListener != null) onConfirmListener(_inputText);
  }

  @override
  void onKeyPressed(String keyName) {
    if (_inputText.length < maxLength) {
      _inputText += keyName;
    }

    if (onPressedListener != null) onPressedListener(_inputText);
  }

  @override
  void onBackspacePressed() {
    if (_inputText.isNotEmpty) {
      _inputText = _inputText.substring(0, _inputText.length - 1);
    }
  }
}
