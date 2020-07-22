import 'package:BWO/Entity/Equipment.dart';
import 'package:BWO/Entity/Items/Items.dart';
import 'package:BWO/Entity/Player/Player.dart';
import 'package:BWO/Entity/Player/PlayerActions.dart';
import 'package:BWO/Utils/OnAnimationEnd.dart';
import 'package:BWO/Utils/SpriteController.dart';
import 'package:flutter/material.dart';

class EquipmentController {
  Equipment _weapon;

  Player player;

  EquipmentController(this.player) {}

  void EquipItem(Item item) {
    _weapon = Equipment(item);
  }

  void draw(Canvas c, bool stopAnimWhenIdle, double animSpeed) {
    _weapon?.currentSprite?.draw(c, player.x, player.y, player.xSpeed,
        player.ySpeed, animSpeed, stopAnimWhenIdle, player.mapHeight);
  }

  void setDirection(Offset targetPos, Offset playerPos) {
    _weapon?.currentSprite?.setDirection(targetPos, playerPos);
  }

  void setAction(DoAction action) {
    if (action == DoAction.Attack) {
      _weapon?.currentSprite = _weapon?.equipmentAttack;
    }
  }

  int getMaxAttackDamage() {
    int damage = player.status.getBaseAttackDamage();
    damage += _weapon != null ? _weapon.item.proprieties.damage : 0;
    return damage;
  }

  int getMaxCutTreeDamage() {
    int damage = player.status.getBaseCutTreeDamage();
    damage += _weapon != null ? _weapon.item.proprieties.treeCut : 0;
    return damage;
  }
}
