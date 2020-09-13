import 'package:flame/sprite.dart';
import 'package:flame/sprite_batch.dart';

class PreloadAssets {
  static final Map<String, Sprite> _enviromentSpriteList = {
    "floor1": Sprite("enviroment/floor1.png"),
    "floor2": Sprite("enviroment/floor2.png"),
    "floor3": Sprite("enviroment/floor3.png"),
    "floor4": Sprite("enviroment/floor4.png"),
    "floor5": Sprite("enviroment/floor5.png"),
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

  static final Map<String, SpriteBatch> _trees = {};

  static final Map<String, Sprite> _wallSpriteList = {
    "wall1": Sprite("walls/wall1.png"),
    "wall2": Sprite("walls/wall2.png"),
    "wall3": Sprite("walls/wall3.png"),
    "wall4": Sprite("walls/wall4.png"),
    "wall5": Sprite("walls/wall5.png"),
    "wall6": Sprite("walls/wall6.png"),
    "wall7": Sprite("walls/wall7.png"),
    "wall8": Sprite("walls/wall8.png"),
    "wall9": Sprite("walls/wall9.png"),
    "wall10": Sprite("walls/wall10.png"),
    "wall11": Sprite("walls/wall11.png"),
    "wall12": Sprite("walls/wall12.png"),
    "wall13": Sprite("walls/wall13.png"),
    "wall13_2": Sprite("walls/wall13_2.png"),
    "wall13_3": Sprite("walls/wall13_3.png"),
    "wall13_4": Sprite("walls/wall13_4.png"),
    "wall13_5": Sprite("walls/wall13_5.png"),
    "wall13_left": Sprite("walls/wall13_left.png"),
    "wall13_right": Sprite("walls/wall13_right.png"),
    "wall14": Sprite("walls/wall14.png"),
    "wall14_2": Sprite("walls/wall14_2.png"),
    "wall14_3": Sprite("walls/wall14_3.png"),
    "wall14_left": Sprite("walls/wall14_left.png"),
    "wall14_right": Sprite("walls/wall14_right.png"),
    "low_wall1": Sprite("walls/low_wall1.png"),
    "low_wall2": Sprite("walls/low_wall2.png"),
    "low_wall3": Sprite("walls/low_wall3.png"),
    "low_wall4": Sprite("walls/low_wall4.png"),
    "low_wall5": Sprite("walls/low_wall5.png"),
    "low_wall6": Sprite("walls/low_wall6.png"),
    "low_wall7": Sprite("walls/low_wall7.png"),
    "low_wall8": Sprite("walls/low_wall8.png"),
    "low_wall9": Sprite("walls/low_wall9.png"),
    "low_wall10": Sprite("walls/low_wall10.png"),
    "low_wall11": Sprite("walls/low_wall11.png"),
    "low_wall12": Sprite("walls/low_wall12.png"),
    "low_wall13": Sprite("walls/low_wall13.png"),
    "low_wall13_2": Sprite("walls/low_wall13_2.png"),
    "low_wall13_3": Sprite("walls/low_wall13_3.png"),
    "low_wall13_4": Sprite("walls/low_wall13_4.png"),
    "low_wall13_5": Sprite("walls/low_wall13_5.png"),
    "low_wall13_left": Sprite("walls/low_wall13_left.png"),
    "low_wall13_right": Sprite("walls/low_wall13_right.png"),
    "low_wall14": Sprite("walls/low_wall14.png"),
    "low_wall14_2": Sprite("walls/low_wall14_2.png"),
    "low_wall14_3": Sprite("walls/low_wall14_3.png"),
    "low_wall14_left": Sprite("walls/low_wall14_left.png"),
    "low_wall14_right": Sprite("walls/low_wall14_right.png"),
  };

  static final Map<String, Sprite> _roofsSpriteList = {
    "roof1": Sprite("roofs/roof1.png"),
    "roof2": Sprite("roofs/roof2.png"),
    "roof3": Sprite("roofs/roof3.png"),
  };

  static final Map<String, Sprite> _floorSpriteList = {
    "floor1": Sprite("floors/floor1.png"),
    "floor2": Sprite("floors/floor2.png"),
    "floor3": Sprite("floors/floor3.png"),
    "floor4": Sprite("floors/floor4.png"),
    "floor5": Sprite("floors/floor5.png"),
    "floor6": Sprite("floors/floor6.png"),
    "floor7": Sprite("floors/floor7.png"),
    "floor8": Sprite("floors/floor8.png"),
    "floor9": Sprite("floors/floor9.png"),
    "floor10": Sprite("floors/floor10.png"),
    "floor11": Sprite("floors/floor11.png"),
    "floor12": Sprite("floors/floor12.png"),
    "floor13": Sprite("floors/floor13.png"),
    "floor14": Sprite("floors/floor14.png"),
    "floor15": Sprite("floors/floor15.png"),
  };

  static final Map<String, Sprite> _effects = {
    "shadown_large": Sprite("shadown_large.png"),
    "shadown_square": Sprite("shadown_square.png"),
    "ripple": Sprite("effects/ripple.png"),
    "rip": Sprite("effects/rip.png"),
  };

  static final Map<String, Sprite> _furnitureList = {
    "bed1": Sprite("furnitures/bed1.png"),
    "refrigerator": Sprite("furnitures/refrigerator.png"),
    "door1": Sprite("furnitures/door1.png"),
    "door1_open": Sprite("furnitures/door1_open.png"),
    "door2": Sprite("furnitures/door2.png"),
    "door2_open": Sprite("furnitures/door2_open.png"),
    "door3": Sprite("furnitures/door3.png"),
    "door3_open": Sprite("furnitures/door3_open.png"),
  };

  static final Map<String, Sprite> _uiSpriteList = {
    "foundation": Sprite("ui/foundation.png"),
    "wall": Sprite("ui/wall.png"),
    "floor_icon": Sprite("ui/floor_icon.png"),
    "furniture": Sprite("ui/furniture.png"),
    "config": Sprite("ui/config.png"),
    "handsaw": Sprite("ui/handsaw.png"),
    "accept": Sprite("ui/accept.png"),
    "cancel": Sprite("ui/cancel.png"),
    "floor1": Sprite("ui/floor1.png"),
    "floor2": Sprite("ui/floor2.png"),
    "floor3": Sprite("ui/floor3.png"),
    "floor4": Sprite("ui/floor4.png"),
    "floor5": Sprite("ui/floor5.png"),
    "floor6": Sprite("ui/floor6.png"),
    "floor7": Sprite("ui/floor7.png"),
    "floor8": Sprite("ui/floor8.png"),
    "floor9": Sprite("ui/floor9.png"),
    "floor10": Sprite("ui/floor10.png"),
    "floor11": Sprite("ui/floor11.png"),
    "floor12": Sprite("ui/floor12.png"),
    "floor13": Sprite("ui/floor13.png"),
    "floor14": Sprite("ui/floor14.png"),
    "floor15": Sprite("ui/floor15.png"),
    "wall1": Sprite("ui/wall1.png"),
    "wall2": Sprite("ui/wall2.png"),
    "wall3": Sprite("ui/wall3.png"),
    "wall4": Sprite("ui/wall4.png"),
    "wall5": Sprite("ui/wall5.png"),
    "wall6": Sprite("ui/wall6.png"),
    "wall7": Sprite("ui/wall7.png"),
    "wall8": Sprite("ui/wall8.png"),
    "wall9": Sprite("ui/wall9.png"),
    "wall10": Sprite("ui/wall10.png"),
    "wall11": Sprite("ui/wall11.png"),
    "wall12": Sprite("ui/wall12.png"),
    "wall13": Sprite("ui/wall13.png"),
    "wall14": Sprite("ui/wall14.png"),
    "bed1": Sprite("ui/bed1.png"),
    "refrigerator": Sprite("ui/refrigerator.png"),
    "door1": Sprite("ui/door1.png"),
    "door2": Sprite("ui/door2.png"),
    "door3": Sprite("ui/door3.png"),
  };

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

  static Sprite getWallSprite(String wall) {
    return _wallSpriteList[wall];
  }

  static Sprite getRoofSprite(String roof) {
    return _roofsSpriteList[roof];
  }

  static Sprite getFloorSprite(String floor) {
    return _floorSpriteList[floor];
  }

  static Sprite getEffectSprite(String effect) {
    return _effects[effect];
  }

  static Sprite getFurnitureSprite(String furniture) {
    return _furnitureList[furniture];
  }

  static Sprite getUiSprite(String ui) {
    return _uiSpriteList[ui];
  }
}
