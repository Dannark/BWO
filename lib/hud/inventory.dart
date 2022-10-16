import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../entity/Items/items.dart';
import '../entity/items/item_database.dart';
import '../entity/player/player.dart';
import '../game_controller.dart';
import '../ui/hud.dart';
import '../ui/ui_element.dart';
import '../utils/tap_state.dart';

class Inventory extends UIElement {
  List<Item> itemList = [];

  final double _margin = 60;

  final int _maxSlots = 4;
  final int _maxHorizontalSlots = 2;
  final double _spaceBetweenSlots = 2;

  final TextPaint _config = TextPaint(
      style: TextStyle(
          fontSize: 11.0, color: Colors.white, fontFamily: "Blocktopia"));
  final Player _player;

  Sprite _bagSprite;
  Sprite _bagSpriteOpen;

  Inventory(this._player, HUD hudRef) : super(hudRef) {
    drawOnHUD = true;
    addItem(Item(0, 0, 0, itemListDatabase[2]));
    addItem(Item(0, 0, 0, itemListDatabase[4]));
    loadSprite();
  }

  void loadSprite() async {
    print("player : ${_player.spriteFolder}");
    if (_player.spriteFolder.contains("female")) {
      _bagSprite = await Sprite.load("ui/bag2.png");
      _bagSpriteOpen = await Sprite.load("ui/bag2_open.png");
    } else {
      _bagSprite = await Sprite.load("ui/bag.png");
      _bagSpriteOpen = await Sprite.load("ui/bag_open.png");
    }
  }

  bool isOpen = false;
  Paint p = Paint();

  int getSize() {
    return itemList.length;
  }

  bool addItem(Item item) {
    var itemAdded = false;

    var found = false;
    for (var itemOnInventory in itemList) {
      if (itemOnInventory.proprieties.name == item.proprieties.name) {
        found = true;
        itemOnInventory.amount++;
        itemAdded = true;
      }
    }

    if (found == false && itemList.length < _maxSlots) {
      itemList.add(item);
      itemAdded = true;
    }

    return itemAdded;
  }

  void drawPosition(Canvas c, double x, double y) {
    drawBagButton(c);

    if (!isOpen) {
      return;
    }

    p.color = Colors.brown[200];
    var maxWidth = _maxHorizontalSlots * 32;
    for (var i = 0; i < _maxSlots; i++) {
      var xSlot = (i % _maxHorizontalSlots) * (32 + _spaceBetweenSlots);
      var ySlot =
          ((i * 32) / maxWidth).floorToDouble() * (32 + _spaceBetweenSlots);
      var maxYSlot = (_maxSlots * 32) / maxWidth * (32 + _spaceBetweenSlots);

      var slotRect = Rect.fromLTWH(
        x + xSlot - maxWidth / 2,
        y + ySlot - _margin - maxYSlot,
        32,
        32,
      );
      c.drawRRect(RRect.fromRectAndRadius(slotRect, Radius.circular(5)), p);

      if (i < getSize()) {
        if (itemList[i].sprite == null) {
          return; //image not ready yet
        }
        itemList[i].sprite.render(c,
            position: Vector2(slotRect.left + 4, slotRect.top + 4),
            size: Vector2.all(1.5));
        _config.render(
          c,
          "${itemList[i].amount}",
          Vector2(slotRect.left + 2, slotRect.top + 1),
        );

        if (GameController.tapState == TapState.down &&
            TapState.instersect(slotRect)) {
          print("Using Item ${itemList[i].proprieties.name}");
          itemList[i].use(_player);
        }
      }
    }
    itemList.removeWhere((element) => element.amount == 0);
  }

  @override
  void draw(Canvas c) {
    var x = GameController.screenSize.width / 2;
    var y = GameController.screenSize.height / 2;

    drawPosition(c, x, y);
  }

  void drawBagButton(Canvas c) {
    if (_bagSprite != null && _bagSpriteOpen != null) {
      var bPos = Vector2(10, GameController.screenSize.height - 128);
      if (isOpen) {
        _bagSpriteOpen.render(c, position: bPos, size: Vector2.all(2));
      } else {
        _bagSprite.render(c, position: bPos, size: Vector2.all(2));
      }

      var bRect = Rect.fromLTWH(bPos.x, bPos.y, 32, 32);
      if (TapState.clickedAt(bRect)) {
        isOpen = !isOpen;
      }
    }
  }
}
