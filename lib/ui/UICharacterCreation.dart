import 'dart:math';
import 'dart:ui';

import 'package:BWO/Scene/GameScene.dart';
import 'package:BWO/Scene/SceneObject.dart';
import 'package:BWO/Utils/TapState.dart';
import 'package:BWO/game_controller.dart';
import 'package:BWO/ui/ButtonUI.dart';
import 'package:BWO/ui/InputTextUI.dart';
import 'package:BWO/ui/UIElement.dart';
import 'package:flame/anchor.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/spritesheet.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';

class UICharacterCreation {
  Paint p = Paint();

  InputTextUI _inputTextUI = InputTextUI(
      Position(GameController.screenSize.width / 2 + 5, 395), "Player Name",
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

  ButtonUI _confirmButton = ButtonUI(
    Rect.fromLTWH(GameController.screenSize.width / 2, 490, 90, 30),
    "Start Game",
  );

  UICharacterCreation() {
    _inputTextUI.onConfirmListener(callback: (String text) {
      if (text.length >= 3) {
        print("Check if the name Choosed $text is avaliable");
      } else {
        print("Name is two short");
      }
    });

    _confirmButton.onPressedListener(callback: () {
      if (_inputTextUI.getText().length > 3) {
        GameController.currentScene = GameScene(_inputTextUI.getText(),
            _mapPreviewWindows.targetPos * GameScene.worldSize.toDouble());
      } else {
        print("can't start the game because the user name is invalid.");
      }
    });
  }

  void draw(Canvas c) {
    p.color = Colors.blueGrey[800];
    c.drawRect(GameController.screenSize, p);
    backPaper.renderRect(c, GameController.screenSize);

    title.render(c, "Character Creation",
        Position((GameController.screenSize.width / 2) + 20, 80),
        anchor: Anchor.bottomCenter);

    _mapPreviewWindows.draw(c);
    _characterPreviewWindows.draw(c);
    _confirmButton.draw(c);
    _inputTextUI.draw(c);
  }
}

class CharacterPreviewWindows {
  Map<int, List<SpriteSheet>> sprites = {};
  List<SpriteSheet> _currentSprite;

  Sprite shadown = Sprite('shadown.png');

  Position myPos;
  int indexSpriteSheet = 2;
  int indexFrame = 0;
  double delay = 0;

  double width = 44;

  CharacterPreviewWindows() {
    sprites[0] = (loadSprite("human"));
    sprites[1] = (loadSprite("human"));
    sprites[2] = (loadSprite("human"));
    sprites[3] = (loadSprite("human"));
    sprites[4] = (loadSprite("human"));
    _currentSprite = sprites[indexSpriteSheet];
    delay = GameController.time + 2;

    myPos = Position(GameController.screenSize.width / 2 + 3, 285);
  }

  void draw(Canvas c) {
    indexSpriteSheet = 2;
    sprites.forEach((key, value) {
      double zoom = .9 - ((key - indexSpriteSheet).abs() * .2);
      Position newPos = myPos +
          Position(
            (key * width - (width * indexSpriteSheet)) - (zoom * width),
            ((16 * 4.0) * (1 - zoom)) / 2,
          );

      if (indexSpriteSheet == key) {
        //shadown.renderScaled(c, myPos + Position(8, 22), scale: 3);
        value[indexFrame].getSprite(0, 0).renderScaled(c, newPos, scale: 4);
      } else {
        var keyDirection = (key - indexSpriteSheet).abs();

        shadown.renderScaled(
            c, newPos + Position(16 / 2 * zoom, (16 + 4) * zoom),
            scale: 3 * zoom);

        Paint alphaP = Paint();
        alphaP.color = Color.fromRGBO(
            255, 255, 255, (0.9 - (keyDirection * .4)).clamp(0.2, 1.0));
        alphaP.blendMode = BlendMode.luminosity; //luminosity, colorBurn, dstOut

        value[0]
            .getSprite(0, 0)
            .renderScaled(c, newPos, scale: 4 * zoom, overridePaint: alphaP);
      }
    });
    _currentSprite = sprites[indexSpriteSheet];

    if (GameController.time > delay) {
      delay = GameController.time + .3;
      indexFrame++;

      if (indexFrame >= _currentSprite.length) {
        indexFrame = 0;
      }
    }
  }

  List<SpriteSheet> loadSprite(String folderName) {
    List<SpriteSheet> sprites = [];
    var images = [
      'forward.png',
      'forward_left.png',
      'left.png',
      'backward_left.png',
      'backward.png',
      'backward_right.png',
      'right.png',
      'forward_right.png',
    ];
    for (var img in images) {
      sprites.add(SpriteSheet(
          imageName: "$folderName/walk/$img",
          textureWidth: 16,
          textureHeight: 16,
          columns: 4,
          rows: 1));
    }
    return sprites;
  }
}

class MapPreviewWindows {
  Paint p = Paint();
  TextConfig location = TextConfig(
      fontSize: 10.0,
      color: Color.fromRGBO(216, 165, 120, 1),
      fontFamily: "Blocktopia");

  Offset targetPos = Offset.zero;

  MapPreviewWindows();

  void draw(Canvas c) {
    Rect bounds = Rect.fromLTWH(60, 85, 150, 150);

    double blockSize = 32;
    //targetPos += Offset(-.5, -.5);

    if (TapState.currentClickingAt(bounds)) {
      targetPos -= TapState.deltaPositionFromStart(limit: 40) *
          GameController.deltaTime *
          3;
    }

    p.color = Color.fromRGBO(139, 123, 90, .16);

    var gridX = targetPos.dx ~/ blockSize;
    var gridY = targetPos.dy ~/ blockSize;

    String legend = "...Endless World";

    c.save();
    c.clipRect(bounds); //start drawning inside mini map objects

    for (int x = gridX - 3; x < gridX + 4; x++) {
      var offset = Offset(-x * blockSize, 0);
      c.drawLine(
        bounds.topCenter + offset + Offset(targetPos.dx, 0),
        bounds.bottomCenter + offset + Offset(targetPos.dx, 0),
        p,
      );
    }

    for (int y = gridY - 3; y < gridY + 4; y++) {
      var offset = Offset(0, -y * blockSize);
      c.drawLine(
        bounds.centerLeft + offset + Offset(0, targetPos.dy),
        bounds.centerRight + offset + Offset(0, targetPos.dy),
        p,
      );
    }

    legend = drawArea(c, 81000, bounds.center, bounds.center, legend,
        "Near the end", "Near the end Field");

    legend = drawArea(c, 9000, bounds.center, bounds.center, legend,
        "Where the good stuff is...", "Craft Field");
    legend = drawArea(c, 3000, bounds.center, bounds.center, legend,
        "*Players vs Player", "Open PVP Field");
    legend = drawArea(c, 1000, bounds.center, bounds.center, legend,
        "Monsters Will Hunt you!", "Hunters Field");
    legend = drawArea(c, 500, bounds.center, bounds.center, legend,
        "Training Area", "Noobie Field");

    legend = drawArea(c, 50, bounds.center, bounds.center, legend, "Safe Area",
        "Starter Village");
    legend = drawArea(c, 50, bounds.center + Offset(0, -750), bounds.center,
        legend, "Safe Area", "North Village");
    legend = drawArea(c, 50, bounds.center + Offset(0, 750), bounds.center,
        legend, "Safe Area", "South Village");
    legend = drawArea(c, 50, bounds.center + Offset(750, 0), bounds.center,
        legend, "Safe Area", "East Village");
    legend = drawArea(c, 50, bounds.center + Offset(-750, 0), bounds.center,
        legend, "Safe Area", "West Village");

    c.restore(); //finish drawning inside mini map objects

    p.color = Color.fromRGBO(216, 165, 120, 1);
    p.strokeWidth = 1;
    p.style = PaintingStyle.stroke;
    c.drawRect(bounds, p);

    p.color = Color.fromRGBO(216, 165, 120, 1);
    c.drawLine(bounds.centerLeft, bounds.centerRight, p);
    c.drawLine(bounds.topCenter, bounds.bottomCenter, p);

    location.render(c, " ${targetPos.dx.toInt()}, ${targetPos.dy.toInt()}",
        Position.fromOffset(bounds.center),
        anchor: Anchor.bottomLeft);

    location.render(c, " $legend", Position.fromOffset(bounds.bottomLeft),
        anchor: Anchor.bottomLeft);

    location.render(c, "Cities:", Position(bounds.right + 5, bounds.top + 0),
        anchor: Anchor.topLeft);
    location.render(
        c, "Starter Village (0,0)", Position(bounds.right + 5, bounds.top + 15),
        anchor: Anchor.topLeft);

    location.render(c, "North Village (0, -750)",
        Position(bounds.right + 5, bounds.top + 30),
        anchor: Anchor.topLeft);
    location.render(c, "South Village (0, 750)",
        Position(bounds.right + 5, bounds.top + 45),
        anchor: Anchor.topLeft);
    location.render(
        c, "East Village (750, 0)", Position(bounds.right + 5, bounds.top + 60),
        anchor: Anchor.topLeft);
    location.render(c, "West Village (-750, 0)",
        Position(bounds.right + 5, bounds.top + 75),
        anchor: Anchor.topLeft);
  }

  String drawArea(Canvas c, double distance, Offset point, Offset midPoint,
      String defaultLegend, String mLegend, String rectName) {
    String legend = defaultLegend;
    // safe area
    Rect safeCityArea = Rect.fromCenter(
        center: point + targetPos, width: distance * 2, height: distance * 2);

    p.color = Color.fromRGBO(216, 165, 120, 1);
    p.strokeWidth = 2;
    c.drawRect(safeCityArea, p);

    if (mLegend == "Safe Area") {
      Paint p2 = Paint();
      p2.color = Color.fromRGBO(216, 165, 120, .1);
      p2.style = PaintingStyle.fill;
      c.drawRect(safeCityArea, p2);
    }

    location.render(c, rectName, Position.fromOffset(safeCityArea.topLeft),
        anchor: Anchor.bottomLeft);

    Rectangle r1 = Rectangle(safeCityArea.left, safeCityArea.top,
        safeCityArea.width, safeCityArea.height);
    Rectangle r2 = Rectangle(midPoint.dx, midPoint.dy, 1, 1);

    if (r1.intersects(r2)) {
      legend = mLegend;
    }
    return legend;
  }
}
