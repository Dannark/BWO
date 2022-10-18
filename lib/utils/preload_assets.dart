import 'package:flame/sprite.dart';

import '../scene/character_creation/character_preview_windows.dart';

class PreloadAssets {
  static Map<int, List<SpriteSheet>> _charSprites = {};

  static Map<String, SpriteBatch> _trees;

  static Map<String, Sprite> _enviromentSpriteList;

  static Map<String, Sprite> _wallSpriteList;

  static Map<String, Sprite> _roofsSpriteList;

  static Map<String, Sprite> _floorSpriteList;

  static Map<String, Sprite> _effects;

  static Map<String, Sprite> _furnitureList;

  static Map<String, Sprite> _uiSpriteList;

  void loadSprites() async {
    print("Loading sprites Chars Assets");

    // shadown = await Sprite.load('shadown.png');

    _charSprites[0] =
        (await CharacterPreviewWindows().loadSprite("human/male1"));
    _charSprites[1] =
        (await CharacterPreviewWindows().loadSprite("human/male2"));
    _charSprites[2] =
        (await CharacterPreviewWindows().loadSprite("human/male3"));
    _charSprites[3] =
        (await CharacterPreviewWindows().loadSprite("human/female1"));
    _charSprites[4] =
        (await CharacterPreviewWindows().loadSprite("human/female2"));
    _charSprites[5] =
        (await CharacterPreviewWindows().loadSprite("human/female3"));
    _charSprites[6] =
        (await CharacterPreviewWindows().loadSprite("human/female4"));
    _charSprites[7] =
        (await CharacterPreviewWindows().loadSprite("human/female5"));
    _charSprites[8] =
        (await CharacterPreviewWindows().loadSprite("human/female6"));

    print("Loading sprites Trees Assets");

    _trees['tree01'] = await SpriteBatch.load('trees/tree01.png');
    _trees['tree02'] = await SpriteBatch.load('trees/tree02.png');
    _trees['tree03'] = await SpriteBatch.load('trees/tree03.png');
    _trees['tree04'] = await SpriteBatch.load('trees/tree04.png');

    _enviromentSpriteList["floor1"] =
        await Sprite.load("enviroment/floor1.png");
    _enviromentSpriteList["floor2"] =
        await Sprite.load("enviroment/floor2.png");
    _enviromentSpriteList["floor3"] =
        await Sprite.load("enviroment/floor3.png");
    _enviromentSpriteList["floor4"] =
        await Sprite.load("enviroment/floor4.png");
    _enviromentSpriteList["floor5"] =
        await Sprite.load("enviroment/floor5.png");
    _enviromentSpriteList["grass1"] =
        await Sprite.load("enviroment/grass1.png");
    _enviromentSpriteList["grass2"] =
        await Sprite.load("enviroment/grass2.png");
    _enviromentSpriteList["grass3"] =
        await Sprite.load("enviroment/grass3.png");
    _enviromentSpriteList["grass4"] =
        await Sprite.load("enviroment/grass4.png");
    _enviromentSpriteList["grass5"] =
        await Sprite.load("enviroment/grass5.png");
    _enviromentSpriteList["grass6"] =
        await Sprite.load("enviroment/grass6.png");
    _enviromentSpriteList["grass7"] =
        await Sprite.load("enviroment/grass7.png");
    _enviromentSpriteList["grass8"] =
        await Sprite.load("enviroment/grass8.png");
    _enviromentSpriteList["grass9"] =
        await Sprite.load("enviroment/grass9.png");
    _enviromentSpriteList["grass10"] =
        await Sprite.load("enviroment/grass10.png");
    _enviromentSpriteList["grass11"] =
        await Sprite.load("enviroment/grass11.png");
    _enviromentSpriteList["grass12"] =
        await Sprite.load("enviroment/grass12.png");
    _enviromentSpriteList["grass13"] =
        await Sprite.load("enviroment/grass13.png");
    _enviromentSpriteList["grass14"] =
        await Sprite.load("enviroment/grass14.png");

    _wallSpriteList["wall1"] = await Sprite.load("walls/wall1.png");
    _wallSpriteList["wall2"] = await Sprite.load("walls/wall2.png");
    _wallSpriteList["wall3"] = await Sprite.load("walls/wall3.png");
    _wallSpriteList["wall4"] = await Sprite.load("walls/wall4.png");
    _wallSpriteList["wall5"] = await Sprite.load("walls/wall5.png");
    _wallSpriteList["wall6"] = await Sprite.load("walls/wall6.png");
    _wallSpriteList["wall7"] = await Sprite.load("walls/wall7.png");
    _wallSpriteList["wall8"] = await Sprite.load("walls/wall8.png");
    _wallSpriteList["wall9"] = await Sprite.load("walls/wall9.png");
    _wallSpriteList["wall10"] = await Sprite.load("walls/wall10.png");
    _wallSpriteList["wall11"] = await Sprite.load("walls/wall11.png");
    _wallSpriteList["wall12"] = await Sprite.load("walls/wall12.png");
    _wallSpriteList["wall13"] = await Sprite.load("walls/wall13.png");
    _wallSpriteList["wall13_2"] = await Sprite.load("walls/wall13_2.png");
    _wallSpriteList["wall13_3"] = await Sprite.load("walls/wall13_3.png");
    _wallSpriteList["wall13_4"] = await Sprite.load("walls/wall13_4.png");
    _wallSpriteList["wall13_5"] = await Sprite.load("walls/wall13_5.png");
    _wallSpriteList["wall13_left"] = await Sprite.load("walls/wall13_left.png");
    _wallSpriteList["wall13_right"] =
        await Sprite.load("walls/wall13_right.png");
    _wallSpriteList["wall14"] = await Sprite.load("walls/wall14.png");
    _wallSpriteList["wall14_2"] = await Sprite.load("walls/wall14_2.png");
    _wallSpriteList["wall14_3"] = await Sprite.load("walls/wall14_3.png");
    _wallSpriteList["wall14_left"] = await Sprite.load("walls/wall14_left.png");
    _wallSpriteList["wall14_right"] =
        await Sprite.load("walls/wall14_right.png");
    _wallSpriteList["low_wall1"] = await Sprite.load("walls/low_wall1.png");
    _wallSpriteList["low_wall2"] = await Sprite.load("walls/low_wall2.png");
    _wallSpriteList["low_wall3"] = await Sprite.load("walls/low_wall3.png");
    _wallSpriteList["low_wall4"] = await Sprite.load("walls/low_wall4.png");
    _wallSpriteList["low_wall5"] = await Sprite.load("walls/low_wall5.png");
    _wallSpriteList["low_wall6"] = await Sprite.load("walls/low_wall6.png");
    _wallSpriteList["low_wall7"] = await Sprite.load("walls/low_wall7.png");
    _wallSpriteList["low_wall8"] = await Sprite.load("walls/low_wall8.png");
    _wallSpriteList["low_wall9"] = await Sprite.load("walls/low_wall9.png");
    _wallSpriteList["low_wall10"] = await Sprite.load("walls/low_wall10.png");
    _wallSpriteList["low_wall11"] = await Sprite.load("walls/low_wall11.png");
    _wallSpriteList["low_wall12"] = await Sprite.load("walls/low_wall12.png");
    _wallSpriteList["low_wall13"] = await Sprite.load("walls/low_wall13.png");
    _wallSpriteList["low_wall13_2"] =
        await Sprite.load("walls/low_wall13_2.png");
    _wallSpriteList["low_wall13_3"] =
        await Sprite.load("walls/low_wall13_3.png");
    _wallSpriteList["low_wall13_4"] =
        await Sprite.load("walls/low_wall13_4.png");
    _wallSpriteList["low_wall13_5"] =
        await Sprite.load("walls/low_wall13_5.png");
    _wallSpriteList["low_wall13_left"] =
        await Sprite.load("walls/low_wall13_left.png");
    _wallSpriteList["low_wall13_right"] =
        await Sprite.load("walls/low_wall13_right.png");
    _wallSpriteList["low_wall14"] = await Sprite.load("walls/low_wall14.png");
    _wallSpriteList["low_wall14_2"] =
        await Sprite.load("walls/low_wall14_2.png");
    _wallSpriteList["low_wall14_3"] =
        await Sprite.load("walls/low_wall14_3.png");
    _wallSpriteList["low_wall14_left"] =
        await Sprite.load("walls/low_wall14_left.png");
    _wallSpriteList["low_wall14_right"] =
        await Sprite.load("walls/low_wall14_right.png");

    _roofsSpriteList["roof1"] = await Sprite.load("roofs/roof1.png");
    _roofsSpriteList["roof2"] = await Sprite.load("roofs/roof2.png");
    _roofsSpriteList["roof3"] = await Sprite.load("roofs/roof3.png");

    _floorSpriteList["floor1"] = await Sprite.load("floors/floor1.png");
    _floorSpriteList["floor2"] = await Sprite.load("floors/floor2.png");
    _floorSpriteList["floor3"] = await Sprite.load("floors/floor3.png");
    _floorSpriteList["floor4"] = await Sprite.load("floors/floor4.png");
    _floorSpriteList["floor5"] = await Sprite.load("floors/floor5.png");
    _floorSpriteList["floor6"] = await Sprite.load("floors/floor6.png");
    _floorSpriteList["floor7"] = await Sprite.load("floors/floor7.png");
    _floorSpriteList["floor8"] = await Sprite.load("floors/floor8.png");
    _floorSpriteList["floor9"] = await Sprite.load("floors/floor9.png");
    _floorSpriteList["floor10"] = await Sprite.load("floors/floor10.png");
    _floorSpriteList["floor11"] = await Sprite.load("floors/floor11.png");
    _floorSpriteList["floor12"] = await Sprite.load("floors/floor12.png");
    _floorSpriteList["floor13"] = await Sprite.load("floors/floor13.png");
    _floorSpriteList["floor14"] = await Sprite.load("floors/floor14.png");
    _floorSpriteList["floor15"] = await Sprite.load("floors/floor15.png");

    _effects["shadown_large"] = await Sprite.load("shadown_large.png");
    _effects["shadown_square"] = await Sprite.load("shadown_square.png");
    _effects["ripple"] = await Sprite.load("effects/ripple.png");
    _effects["rip"] = await Sprite.load("effects/rip.png");

    _furnitureList["bed1"] = await Sprite.load("furnitures/bed1.png");
    _furnitureList["refrigerator"] =
        await Sprite.load("furnitures/refrigerator.png");
    _furnitureList["door1"] = await Sprite.load("furnitures/door1.png");
    _furnitureList["door1_open"] =
        await Sprite.load("furnitures/door1_open.png");
    _furnitureList["door2"] = await Sprite.load("furnitures/door2.png");
    _furnitureList["door2_open"] =
        await Sprite.load("furnitures/door2_open.png");
    _furnitureList["door3"] = await Sprite.load("furnitures/door3.png");
    _furnitureList["door3_open"] =
        await Sprite.load("furnitures/door3_open.png");

    _uiSpriteList["foundation"] = await Sprite.load("ui/foundation.png");
    _uiSpriteList["wall"] = await Sprite.load("ui/wall.png");
    _uiSpriteList["floor_icon"] = await Sprite.load("ui/floor_icon.png");
    _uiSpriteList["furniture"] = await Sprite.load("ui/furniture.png");
    _uiSpriteList["config"] = await Sprite.load("ui/config.png");
    _uiSpriteList["handsaw"] = await Sprite.load("ui/handsaw.png");
    _uiSpriteList["accept"] = await Sprite.load("ui/accept.png");
    _uiSpriteList["cancel"] = await Sprite.load("ui/cancel.png");
    _uiSpriteList["floor1"] = await Sprite.load("ui/floor1.png");
    _uiSpriteList["floor2"] = await Sprite.load("ui/floor2.png");
    _uiSpriteList["floor3"] = await Sprite.load("ui/floor3.png");
    _uiSpriteList["floor4"] = await Sprite.load("ui/floor4.png");
    _uiSpriteList["floor5"] = await Sprite.load("ui/floor5.png");
    _uiSpriteList["floor6"] = await Sprite.load("ui/floor6.png");
    _uiSpriteList["floor7"] = await Sprite.load("ui/floor7.png");
    _uiSpriteList["floor8"] = await Sprite.load("ui/floor8.png");
    _uiSpriteList["floor9"] = await Sprite.load("ui/floor9.png");
    _uiSpriteList["floor10"] = await Sprite.load("ui/floor10.png");
    _uiSpriteList["floor11"] = await Sprite.load("ui/floor11.png");
    _uiSpriteList["floor12"] = await Sprite.load("ui/floor12.png");
    _uiSpriteList["floor13"] = await Sprite.load("ui/floor13.png");
    _uiSpriteList["floor14"] = await Sprite.load("ui/floor14.png");
    _uiSpriteList["floor15"] = await Sprite.load("ui/floor15.png");
    _uiSpriteList["wall1"] = await Sprite.load("ui/wall1.png");
    _uiSpriteList["wall2"] = await Sprite.load("ui/wall2.png");
    _uiSpriteList["wall3"] = await Sprite.load("ui/wall3.png");
    _uiSpriteList["wall4"] = await Sprite.load("ui/wall4.png");
    _uiSpriteList["wall5"] = await Sprite.load("ui/wall5.png");
    _uiSpriteList["wall6"] = await Sprite.load("ui/wall6.png");
    _uiSpriteList["wall7"] = await Sprite.load("ui/wall7.png");
    _uiSpriteList["wall8"] = await Sprite.load("ui/wall8.png");
    _uiSpriteList["wall9"] = await Sprite.load("ui/wall9.png");
    _uiSpriteList["wall10"] = await Sprite.load("ui/wall10.png");
    _uiSpriteList["wall11"] = await Sprite.load("ui/wall11.png");
    _uiSpriteList["wall12"] = await Sprite.load("ui/wall12.png");
    _uiSpriteList["wall13"] = await Sprite.load("ui/wall13.png");
    _uiSpriteList["wall14"] = await Sprite.load("ui/wall14.png");
    _uiSpriteList["bed1"] = await Sprite.load("ui/bed1.png");
    _uiSpriteList["refrigerator"] = await Sprite.load("ui/refrigerator.png");
    _uiSpriteList["door1"] = await Sprite.load("ui/door1.png");
    _uiSpriteList["door2"] = await Sprite.load("ui/door2.png");
    _uiSpriteList["door3"] = await Sprite.load("ui/door3.png");
  }

  static Map<int, List<SpriteSheet>> getChars() {
    return _charSprites;
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
