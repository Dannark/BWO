import 'dart:ffi';

class Status {
  int _hp;
  int _maxHP;

  int _energy;
  int _maxEnergy;

  int _force = 2;

  int _level = 1;
  int _exp = 0;
  int _maxExp = 0;

  Status({int maxHP = 10, int maxEnergy = 5}) {
    this._maxHP = maxHP;
    this._maxEnergy = maxEnergy;

    refillStatus();
  }

  int getHP() {
    return _hp;
  }

  int getEnergy() {
    return _energy;
  }

  void takeDamage(int damage) {
    _hp -= damage;
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

  bool isAlive() {
    return _hp > 0;
  }

  void refillStatus() {
    _hp = _maxHP;
    _energy = _maxEnergy;
  }

  void setLife(int n) {
    _maxEnergy = n;
    _hp = _maxEnergy;
  }

  void addExp(int amount) {
    _exp += amount;
  }

  int getMaxAttackPoint() {
    return _force;
  }
}
