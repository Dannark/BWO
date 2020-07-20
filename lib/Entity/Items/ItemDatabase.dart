class ItemDatabase {
  static Map<int, ItemDB> itemList = {
    0: ItemDB("Apple", "items/apple3.png", 1,
        useEffects: true, hp: 4, hungriness: 35),
    1: ItemDB("Log", "items/log.png", 2),
    2: ItemDB("Green Apple", "items/apple_green.png", 1,
        useEffects: true, energy: 5, hungriness: 50),
    3: ItemDB("Orange", "items/orange.png", 1),
  };
}

class ItemDB {
  String name, imgPath;
  double zoom = 1;

  //useable Effects
  bool useEffects = false;
  int hp = 0;
  int energy = 0;
  double hungriness = 0;

  ItemDB(
    this.name,
    this.imgPath,
    this.zoom, {
    this.useEffects = false,
    this.hp = 0,
    this.energy = 0,
    this.hungriness = 0,
  });
}
