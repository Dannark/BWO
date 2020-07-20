import 'dart:ffi';

import 'package:BWO/game_controller.dart';

class Status {
  int _hp;
  int _maxHP;

  double _energy;
  double _maxEnergy;

  double _hungriness = 0;
  double _maxHungriness = 100;

  int _force = 2;

  int _level = 1;
  double _exp = 0;
  double _maxExp = 1;

  //regenaration settings
  bool autoRegenHP = true;
  double _hpRegenFrequency = 10; //in seconds
  double _hpRegenTime = 0;
  double _energyRegenSpeed = .5;
  double _hungrinessDecressSpeed = .25;

  Status({int maxHP = 10, double maxEnergy = 5}) {
    this._maxHP = maxHP;
    this._maxEnergy = maxEnergy;

    refillStatus();
  }

  void update(double walkSpeed) {
    _statusRegeneration(walkSpeed);
    _levelUpRamp();
  }

  void _statusRegeneration(double walkSpeed) {
    if (isAlive() == false) return;

    if (_hungriness > 0) {
      _hungriness -= GameController.deltaTime * _hungrinessDecressSpeed;
    }

    if (walkSpeed >= 2) {
      if (_energy > 0) {
        _energy -= GameController.deltaTime * _energyRegenSpeed * .5;
      }
    } else {
      if (_energy < _maxEnergy) {
        _energy += GameController.deltaTime *
            _energyRegenSpeed *
            2 *
            (_hungriness / 100);
      }
    }

    if (autoRegenHP == false) return;
    if (_hp < _maxHP && GameController.time > _hpRegenTime) {
      if (walkSpeed == 0) {
        _hpRegenTime = GameController.time + _hpRegenFrequency * .5;
      } else {
        _hpRegenTime = GameController.time + _hpRegenFrequency;
      }
      _hp += 1;
    }
  }

  int getLevel() {
    return _level;
  }

  int getHP() {
    return _hp;
  }

  int getMaxHP() {
    return _maxHP;
  }

  double getEnergy() {
    return _energy;
  }

  double getMaxEnergy() {
    return _maxEnergy;
  }

  double getExp() {
    return _exp;
  }

  double getMaxExp() {
    return _maxExp;
  }

  double getHungriness() {
    return _hungriness;
  }

  double getMaxHungriness() {
    return _maxHungriness;
  }

  void takeDamage(int damage) {
    _hp -= damage;
    if (_hp < 0) {
      _hp = 0;
    }

    //resets the time to not auto regenerate status
    _hpRegenTime = GameController.time + _hpRegenFrequency * 2;
  }

  bool useEnergy(int energy) {
    if (_energy >= energy) {
      _energy -= energy;

      //resets the time to not auto regenerate status
      _hpRegenTime = GameController.time + _hpRegenFrequency * 2;
      return true;
    } else {
      return false;
    }
  }

  void addLife(int life) {
    _hp += life;
    if (_hp > _maxHP) {
      _hp = _maxHP;
    }
  }

  void addEnergy(int energy) {
    _energy += energy;
    if (_energy > _maxEnergy) {
      _energy = _maxEnergy;
    }
  }

  void addHungriness(double hungriness) {
    _hungriness += hungriness;
    if (_hungriness > _maxHungriness) {
      _hungriness = _maxHungriness;
    }
  }

  bool isAlive() {
    return _hp > 0;
  }

  void refillStatus() {
    _hp = _maxHP;
    _energy = _maxEnergy;
    _hungriness = _maxHungriness;
  }

  void setLife(int n) {
    _maxHP = n;
    _hp = _maxHP;
  }

  void addExp(int amount) {
    _exp += amount;
    _levelUpRamp();
  }

  int getMaxAttackPoint() {
    return _force;
  }

  void _levelUpRamp() {
    int startBaseExp = 10;
    double rampMultiplier = .35;
    _maxExp =
        _level * startBaseExp + ((_level * _level * _level) * rampMultiplier);

    _maxHP = (10 + ((_level * _level) * .5)).toInt();
    _maxEnergy = (5 + _level * .5);

    if (_exp > _maxExp) {
      _level++;
      _exp -= _maxExp;
      print("level up");
      refillStatus();
    }
  }
}
