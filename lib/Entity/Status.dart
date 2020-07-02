import 'dart:ffi';

class Status {
  int _hp;
  int _maxHP;

  int _energy;
  int _maxEnergy;

  Status({int maxHP = 10, int maxEnergy = 5}) {
    this._maxHP = maxHP;
    this._maxEnergy = maxEnergy;

    refillStatus();
  }

  void takeDamage(int damage) {
    _hp -= damage;
  }

  void addLife(int life) {
    print("${_hp} ${life}");
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
}
