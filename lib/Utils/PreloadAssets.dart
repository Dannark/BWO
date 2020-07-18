import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame/sprite_batch.dart';

class PreloadAssets {
  static Map<String, Sprite> _enviromentSpriteList = {
    "floor1": Sprite("enviroment/floor1.png"),
    "floor2": Sprite("enviroment/floor2.png"),
    "floor3": Sprite("enviroment/floor3.png"),
    "grass1": Sprite("enviroment/grass1.png"),
    "grass2": Sprite("enviroment/grass2.png"),
    "grass3": Sprite("enviroment/grass3.png"),
    "grass4": Sprite("enviroment/grass4.png"),
    "grass5": Sprite("enviroment/grass5.png"),
    "grass6": Sprite("enviroment/grass6.png"),
    "grass7": Sprite("enviroment/grass7.png"),
    "grass8": Sprite("enviroment/grass8.png"),
    "grass9": Sprite("enviroment/grass9.png"),
    "grass10": Sprite("enviroment/grass10.png"),
    "grass11": Sprite("enviroment/grass11.png"),
    "grass12": Sprite("enviroment/grass12.png"),
    "grass13": Sprite("enviroment/grass13.png"),
    "grass14": Sprite("enviroment/grass14.png"),
  };

  static Map<String, SpriteBatch> _trees = {};

  PreloadAssets() {
    loadSprites();
  }

  void loadSprites() async {
    print("Loading sprites Trees Assets");
    SpriteBatch.withAsset('trees/tree01.png')
        .then((value) => _trees['tree01'] = value);
    SpriteBatch.withAsset('trees/tree02.png')
        .then((value) => _trees['tree02'] = value);
    SpriteBatch.withAsset('trees/tree03.png')
        .then((value) => _trees['tree03'] = value);
    SpriteBatch.withAsset('trees/tree04.png')
        .then((value) => _trees['tree04'] = value);
  }

  static Sprite getEnviromentSprite(String grass) {
    return _enviromentSpriteList[grass];
  }

  static SpriteBatch getTreeSprite(String tree) {
    return _trees[tree];
  }
}
