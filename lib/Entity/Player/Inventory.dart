import 'package:BWO/Entity/Items/ItemDatabase.dart';
import 'package:BWO/Entity/Items/Items.dart';
import 'package:BWO/Entity/Player/Player.dart';
import 'package:BWO/ui/UIElement.dart';
import 'package:BWO/game_controller.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';

class Inventory implements UIElement {
  List<Item> itemList = [];

  double margin = 60;

  int maxSlots = 4;
  int maxHorizontalSlots = 2;
  double spaceBetweenSlots = 2;

  TextConfig config =
      TextConfig(fontSize: 11.0, color: Colors.white, fontFamily: "Blocktopia");
  Player _player;

  Sprite _bagSprite;
  Sprite _bagSpriteOpen;

  Inventory(this._player) {
    GameController.uiController.hud.addElement(this);
    addItem(Item(0, 0, 0, ItemDatabase.itemList[2]));
    // addItem(Item(0, 0, 0, ItemDatabase.itemList[3]));
    loadSprite();
  }

  void loadSprite() async {
    _bagSprite = await Sprite.loadSprite("items/bag.png");
    _bagSpriteOpen = await Sprite.loadSprite("items/bag_open.png");
  }

  bool isOpen = false;
  Paint p = Paint();

  int getSize() {
    return itemList.length;
  }

  bool addItem(Item item) {
    bool itemAdded = false;

    bool found = false;
    for (var itemOnInventory in itemList) {
      if (itemOnInventory.proprieties.name == item.proprieties.name) {
        found = true;
        itemOnInventory.amount++;
        itemAdded = true;
      }
    }

    if (found == false && itemList.length < maxSlots) {
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
    var maxWidth = maxHorizontalSlots * 32;
    for (int i = 0; i < maxSlots; i++) {
      var xSlot = (i % maxHorizontalSlots) * (32 + spaceBetweenSlots);
      var ySlot =
          ((i * 32) / maxWidth).floorToDouble() * (32 + spaceBetweenSlots);
      var maxYSlot = (maxSlots * 32) / maxWidth * (32 + spaceBetweenSlots);

      Rect slotRect = Rect.fromLTWH(
        x + xSlot - maxWidth / 2,
        y + ySlot - margin - maxYSlot,
        32,
        32,
      );
      c.drawRRect(RRect.fromRectAndRadius(slotRect, Radius.circular(5)), p);

      if (i < getSize()) {
        if (itemList[i].sprite == null) {
          return; //image not ready yet
        }
        itemList[i].sprite.renderScaled(
            c, Position(slotRect.left + 4, slotRect.top + 4),
            scale: 1.5);
        config.render(
          c,
          "${itemList[i].amount}",
          Position(slotRect.left + 2, slotRect.top + 1),
        );

        if (GameController.tapState == TapState.DOWN &&
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
      Position bPos = Position(10, GameController.screenSize.height - 128);
      if (isOpen) {
        _bagSpriteOpen.renderScaled(c, bPos, scale: 2);
      } else {
        _bagSprite.renderScaled(c, bPos, scale: 2);
      }

      Rect bRect = Rect.fromLTWH(bPos.x, bPos.y, 32, 32);
      if (TapState.clickedAt(bRect)) {
        isOpen = !isOpen;
      }
    }
  }
}
