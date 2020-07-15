import 'package:BWO/Scene/CharacterCreation/CharacterPreviewWindows.dart';
import 'package:BWO/Scene/CharacterCreation/MapViewWindows.dart';
import 'package:BWO/Scene/GameScene.dart';
import 'package:BWO/Scene/SceneObject.dart';
import 'package:BWO/game_controller.dart';
import 'package:BWO/ui/ButtonUI.dart';
import 'package:BWO/ui/InputTextUI.dart';
import 'package:flame/anchor.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';

class CharacterCreation extends SceneObject {
  Paint p = Paint();

  InputTextUI _inputTextUI = InputTextUI(
      Position(GameController.screenSize.width / 2 + 5, 412), "Player Name",
      backGroundColor: Color.fromRGBO(255, 255, 255, 0),
      normalColor: Color.fromRGBO(64, 44, 40, 1),
      placeholderColor: Color.fromRGBO(216, 165, 120, 1),
      rotation: -0.05);

  TextConfig title = TextConfig(
      fontSize: 22.0,
      color: Color.fromRGBO(216, 165, 120, 1),
      fontFamily: "Blocktopia");
  TextConfig smallText =
      TextConfig(fontSize: 14.0, color: Colors.white, fontFamily: "Blocktopia");

  Sprite backPaper = Sprite("ui/backpaper.png");

  MapPreviewWindows _mapPreviewWindows = MapPreviewWindows();
  CharacterPreviewWindows _characterPreviewWindows = CharacterPreviewWindows();

  ButtonUI _startGameButton = ButtonUI(
    Rect.fromLTWH(GameController.screenSize.width / 2, 490, 100, 30),
    "Start Game",
    //normalColor: Color.fromRGBO(50, 143, 249, 1),
  );

  CharacterCreation() {
    _inputTextUI.onConfirmListener(callback: (String text) {
      if (text.length >= 3) {
        print("Check if the name Choosed $text is avaliable");
      } else {
        print("Name is two short");
      }
    });

    _startGameButton.onPressedListener(callback: () {
      if (_inputTextUI.getText().length > 3) {
        GameController.currentScene = GameScene(_inputTextUI.getText(),
            -_mapPreviewWindows.targetPos * GameScene.worldSize.toDouble());
      } else {
        print("can't start the game because the user name is invalid.");
      }
    });
  }

  @override
  void draw(Canvas c) {
    super.draw(c);

    p.color = Colors.blueGrey[800];
    c.drawRect(GameController.screenSize, p);
    backPaper.renderRect(c, GameController.screenSize);

    title.render(c, "Character Creation",
        Position((GameController.screenSize.width / 2) + 20, 85),
        anchor: Anchor.bottomCenter);

    _mapPreviewWindows.draw(c);
    _characterPreviewWindows.draw(c);
    _inputTextUI.draw(c);
    _startGameButton.draw(c);
  }

  @override
  void update() {
    super.update();
  }
}
