import 'package:flutter/material.dart';

import 'equipment.dart';
import 'items/items.dart';
import 'player/player.dart';
import 'player/player_actions.dart';

class EquipmentController {
  Equipment _weapon;

  Player player;

  EquipmentController(this.player);

  void equipItem(Item item) {
    _weapon = Equipment(item);
  }

  void draw(Canvas c, double animSpeed, {bool stopAnimWhenIdle = true}) {
    _weapon?.currentSprite?.draw(c, player.x, player.y, player.xSpeed,
        player.ySpeed, animSpeed, player.mapHeight,
        stopAnimWhenIdle: stopAnimWhenIdle);
  }

  void setDirection(Offset targetPos, Offset playerPos) {
    _weapon?.currentSprite?.setDirection(targetPos, playerPos);
  }

  void setAction(DoAction action) {
    if (action == DoAction.attack) {
      _weapon?.currentSprite = _weapon?.equipmentAttack;
    }
  }

  int getMaxAttackDamage() {
    var damage = player.status.getBaseAttackDamage();
    damage += _weapon != null ? _weapon.item.proprieties.damage : 0;
    return damage;
  }

  int getMaxCutTreeDamage() {
    var damage = player.status.getBaseCutTreeDamage();
    damage += _weapon != null ? _weapon.item.proprieties.treeCut : 0;
    return damage;
  }
}
