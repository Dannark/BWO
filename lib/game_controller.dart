import 'dart:math';
import 'dart:ui';
import 'package:BWO/Effects/EffectsController.dart';
import 'package:BWO/Entity/Enemys/Enemy.dart';
import 'package:BWO/Entity/Enemys/Skull.dart';
import 'package:BWO/Entity/Player/Player.dart';
import 'package:BWO/Scene/GameScene.dart';
import 'package:BWO/Scene/HomeScene.dart';
import 'package:BWO/Scene/SceneObject.dart';
import 'package:BWO/Server/ServerController.dart';
import 'package:BWO/ui/UIController2.dart';
import 'package:BWO/Map/map_controller.dart';
import 'package:BWO/Utils/PhysicsController.dart';
import 'package:BWO/Utils/TapState.dart';
import 'package:flame/anchor.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';

class GameController extends Game with PanDetector, WidgetsBindingObserver {
  static Size screenSize;
  static double fps;

  static double deltaTime = 0;
  static double time = 0;
  static int tapState = TapState.UP;
  static int preTapState = TapState.UP;

  static SceneObject currentScene;

  // Skull skull;

  GameController() {
    currentScene = HomeScene();
    //_gameScene = GameScene(); //init Game;

    // skull = new Skull(-300, 32, mapController);
    // mapController.addEntity(skull);
  }

  void render(Canvas c) {
    Rect bgRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint bgPaint = Paint();
    bgPaint.color = Color(0xff000000);
    c.drawRect(bgRect, bgPaint);

    currentScene.draw(c);
    EffectsController.draw(c);

    if (tapState == TapState.DOWN) {
      tapState = TapState.PRESSING;
    }
  }

  void update(double dt) {
    fps = 1.0 / dt;
    deltaTime = dt;
    time += dt;

    if (preTapState == TapState.DOWN) {
      tapState = TapState.DOWN;
      preTapState = TapState.UP;
    }

    currentScene.update();
  }

  void resize(Size size) {
    screenSize = size;
    super.resize(size);
  }

  @override
  void onPanDown(DragDownDetails details) {
    preTapState = TapState.DOWN;
    TapState.localPosition = details.localPosition;
  }

  @override
  void onPanEnd(DragEndDetails details) {
    tapState = TapState.UP;
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    // TODO: implement lifecycleStateChange
    super.lifecycleStateChange(state);
    print("state = ${state}");
  }
}
