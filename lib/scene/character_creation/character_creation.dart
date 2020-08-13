import 'package:flame/anchor.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';

import '../../game_controller.dart';
import '../../ui/button_ui.dart';
import '../../ui/input_text_ui.dart';
import '../game_scene.dart';
import '../scene_object.dart';
import 'character_preview_windows.dart';
import 'map_view_windows.dart';

class CharacterCreation extends SceneObject {
  final Paint _p = Paint();

  InputTextUI _inputTextUI;

  final TextConfig _title = TextConfig(
      fontSize: 22.0,
      color: Color.fromRGBO(216, 165, 120, 1),
      fontFamily: "Blocktopia");

  final Sprite _backPaper = Sprite("ui/backpaper.png");

  MapPreviewWindows _mapPreviewWindows;
  final CharacterPreviewWindows _characterPreviewWindows =
      CharacterPreviewWindows();

  ButtonUI _startGameButton;

  CharacterCreation() {
    _mapPreviewWindows = MapPreviewWindows(super.hud);

    _inputTextUI = InputTextUI(super.hud,
        Position(GameController.screenSize.width / 2 + 5, 412), "Player Name",
        backGroundColor: Color.fromRGBO(255, 255, 255, 0),
        normalColor: Color.fromRGBO(64, 44, 40, 1),
        placeholderColor: Color.fromRGBO(216, 165, 120, 1),
        rotation: -0.05);

    _startGameButton = ButtonUI(
      super.hud,
      Rect.fromLTWH(GameController.screenSize.width / 2, 490, 100, 30),
      "Start Game",
    );

    _inputTextUI.onConfirmListener = (text) {
      if (text.length >= 3) {
        print("Check if the name Choosed $text is avaliable");
      } else {
        print("Name is two short");
      }
    };

    _startGameButton.onPressedListener = () {
      if (_inputTextUI.getText().length >= 3) {
        GameController.currentScene = GameScene(
            _inputTextUI.getText(),
            -_mapPreviewWindows.targetPos * GameScene.worldSize.toDouble(),
            _characterPreviewWindows.getSpriteSelected());
      } else {
        print("can't start the game because the user name is invalid.");
      }
    };
  }

  @override
  void draw(Canvas c) {
    super.draw(c);

    _p.color = Colors.blueGrey[800];
    c.drawRect(GameController.screenSize, _p);
    _backPaper.renderRect(c, GameController.screenSize);

    _title.render(c, "Character Creation",
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
