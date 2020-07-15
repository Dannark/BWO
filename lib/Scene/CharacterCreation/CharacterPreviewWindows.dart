import 'dart:ui';

import 'package:BWO/game_controller.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/spritesheet.dart';

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
    sprites[0] = (loadSprite("human/male1"));
    sprites[1] = (loadSprite("human/male2"));
    sprites[2] = (loadSprite("human/female1"));
    sprites[3] = (loadSprite("human/male1"));
    sprites[4] = (loadSprite("human/male1"));
    _currentSprite = sprites[indexSpriteSheet];
    delay = GameController.time + 2;

    myPos = Position(GameController.screenSize.width / 2 + 3, 310);
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
