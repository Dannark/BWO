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

  bool isAlive() {
    return _hp > 0;
  }

  void refillStatus() {
    _hp = _maxHP;
    _energy = _maxEnergy;
  }
}
