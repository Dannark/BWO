import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/spritesheet.dart';

import '../../game_controller.dart';
import '../../utils/tap_state.dart';

class CharacterPreviewWindows {
  Map<int, List<SpriteSheet>> sprites = {};
  List<SpriteSheet> _currentSprite;

  List<String> spriteFolder = [];
  String currentSpriteFolder;

  Sprite shadown = Sprite('shadown.png');

  Position myPos;
  int indexSpriteSheet = 2;
  int indexFrame = 0;
  double delay = 0;

  final double width = 44;

  CharacterPreviewWindows() {
    sprites[0] = (loadSprite("human/male1"));
    sprites[1] = (loadSprite("human/male2"));
    sprites[2] = (loadSprite("human/male3"));
    sprites[3] = (loadSprite("human/female1"));
    sprites[4] = (loadSprite("human/female2"));
    sprites[5] = (loadSprite("human/female3"));
    sprites[6] = (loadSprite("human/female4"));
    sprites[7] = (loadSprite("human/female5"));
    sprites[8] = (loadSprite("human/female6"));
    _currentSprite = sprites[indexSpriteSheet];
    delay = GameController.time + 2;

    myPos = Position(
      GameController.screenSize.width / 2 + 3,
      GameController.screenSize.height * .5,
    );
  }

  void draw(Canvas c) {
    var leftButton = Rect.fromLTWH(myPos.x - 113, myPos.y, 80, 70);
    var rightButton = Rect.fromLTWH(myPos.x + 18, myPos.y, 80, 70);

    if (TapState.clickedAt(leftButton)) {
      indexSpriteSheet--;
    }
    if (TapState.clickedAt(rightButton)) {
      indexSpriteSheet++;
    }
    indexSpriteSheet = indexSpriteSheet.clamp(0, sprites.length - 1);

    var clipRect = Rect.fromLTWH(myPos.x - 115, myPos.y - 10, 220, 90);
    c.clipRect(clipRect);
    sprites.forEach((key, value) {
      var zoom = .9 - ((key - indexSpriteSheet).abs() * .2);
      var newPos = myPos +
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

        var alphaP = Paint();
        alphaP.color = Color.fromRGBO(
            255, 255, 255, (0.9 - (keyDirection * .4)).clamp(0.2, 1.0));
        alphaP.blendMode = BlendMode.luminosity; //luminosity, colorBurn, dstOut

        value[0]
            .getSprite(0, 0)
            .renderScaled(c, newPos, scale: 4 * zoom, overridePaint: alphaP);
      }
    });
    c.restore();
    _currentSprite = sprites[indexSpriteSheet];
    currentSpriteFolder = spriteFolder[indexSpriteSheet];

    if (GameController.time > delay) {
      delay = GameController.time + .3;
      indexFrame++;

      if (indexFrame >= _currentSprite.length) {
        indexFrame = 0;
      }
    }
  }

  List<SpriteSheet> loadSprite(String folderName) {
    spriteFolder.add(folderName);
    // ignore: omit_local_variable_types
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

  String getSpriteSelected() {
    return currentSpriteFolder;
  }
}
