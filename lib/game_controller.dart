import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';

import 'scene/character_creation/character_creation.dart';
import 'scene/login/login.dart';
import 'scene/scene_object.dart';
import 'server/utils/server_utils.dart';
import 'ui/keyboard/keyboard_ui.dart';
import 'utils/preload_assets.dart';
import 'utils/tap_state.dart';

class GameController extends Game with PanDetector {
  static Rect screenSize;
  static double fps = 0;

  static double deltaTime = 0;
  static double time = 0;
  static int tapState = TapState.up;
  static int preTapState = TapState.up;

  static SceneObject currentScene;

  GameController() {
    PreloadAssets();
    //_gameScene = GameScene(); //init Game;
  }

  void _safeStart() {
    if (currentScene == null) {
      KeyboardUI.build();
      if (ServerUtils.isOffline) {
        currentScene = CharacterCreation(null);
      } else {
        currentScene = Login();
      }
    }
  }

  void render(Canvas c) {
    if (screenSize == null) return;

    var bgPaint = Paint();
    bgPaint.color = Color(0xff000000);
    c.drawRect(screenSize, bgPaint);

    currentScene.draw(c);
    KeyboardUI.draw(c);

    if (tapState == TapState.down) {
      tapState = TapState.pressing;
    }
  }

  List<double> fpsList = [];

  void update(double dt) {
    if (screenSize == null) return;

    deltaTime = dt;
    time += dt;

    fpsList.add(1.0 / dt);
    var avg = 0.0;

    for (var fps in fpsList) {
      avg += fps;
    }
    fps = avg / fpsList.length;

    if (fpsList.length > 20) {
      fpsList.removeAt(0);
    }

    if (preTapState == TapState.down) {
      tapState = TapState.down;
      preTapState = TapState.up;
    }

    currentScene.update();
  }

  void resize(Size size) {
    super.resize(size);
    print('Starting game with $size');
    screenSize = Rect.fromLTWH(0, 0, size.width, size.height);

    _safeStart();
  }

  @override
  void onPanDown(DragDownDetails details) {
    preTapState = TapState.down;
    TapState.pressedPosition = details.localPosition;
    TapState.currentPosition = details.localPosition;
    TapState.lastPosition = details.localPosition;
  }

  @override
  void onPanUpdate(DragUpdateDetails details) {
    if (tapState == TapState.pressing) {
      TapState.lastPosition = TapState.currentPosition;
      TapState.currentPosition = details.localPosition;
    }
  }

  @override
  void onPanEnd(DragEndDetails details) {
    tapState = TapState.up;
  }
}
