import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import '../../game_controller.dart';
import '../entity.dart';
import '../player/player.dart';
import 'item_database.dart';

class Item extends Entity {
  ItemDB proprieties;
  Sprite sprite;

  double lifeTime = 0;
  Paint p = Paint();

  double alphaBlink = 1;
  double blinkTimeBeforeDelete = 0;

  int amount = 1;

  Item(double x, double y, double z, this.proprieties) : super(x, y) {
    super.z = z;
    bounciness = 0.12;
    lifeTime = GameController.time + 16;
    loadSprite();
    shadownSize = proprieties.zoom;

    isCollisionTrigger = true; //make item to be pickedUp
  }

  void loadSprite() async {
    sprite = await Sprite.load(proprieties.imgPath);
  }

  @override
  void draw(Canvas c) {
    if (sprite != null) {
      if (GameController.time > lifeTime - 3) {
        blink(.08);
      } else if (GameController.time > lifeTime - 6) {
        blink(.2);
      }

      p.color = Color.fromRGBO(255, 255, 255, alphaBlink);

      var pivot = Offset((proprieties.zoom * 16) / 2, (proprieties.zoom * 16));
      sprite.render(c,
          position: Vector2(x - pivot.dx, y - pivot.dy - z),
          size: Vector2.all(proprieties.zoom),
          overridePaint: p);
      updatePhysics();

      if (GameController.time > lifeTime) {
        destroy();
      }

      //debugDraw(c);
    }
  }

  void use(Entity playerEntity) {
    if (proprieties.itemType == ItemType.usable) {
      amount--; //removes item from inventory
      playerEntity.status.addLife(proprieties.hp);
      playerEntity.status.addEnergy(proprieties.energy);
      playerEntity.status.addHungriness(proprieties.hungriness);

      FlameAudio.play("items/eating_apple.mp3", volume: 0.3);
    } else if (proprieties.itemType == ItemType.weapon) {
      if (playerEntity is Player) {
        amount--; //removes item from inventory
        playerEntity.equipmentController.equipItem(this);
      }
    }
  }

  void blink(double speed) {
    if (GameController.time > blinkTimeBeforeDelete) {
      blinkTimeBeforeDelete = GameController.time + speed;
      alphaBlink = alphaBlink < 1 ? 1 : .3;
    }
  }
}
