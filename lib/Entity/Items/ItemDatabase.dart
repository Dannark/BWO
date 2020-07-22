class ItemDatabase {
  static Map<int, ItemDB> itemList = {
    0: ItemDB("Apple", "items/apple3.png", 1,
        hp: 4, hungriness: 35, itemType: ItemType.Usable),
    1: ItemDB("Log", "items/log.png", 2),
    2: ItemDB("Green Apple", "items/apple_green.png", 1,
        itemType: ItemType.Usable, energy: 5, hungriness: 50),
    3: ItemDB("Orange", "items/orange.png", 1, itemType: ItemType.Usable),
    4: ItemDB("Wood Axe", "items/axe.png", 1,
        itemType: ItemType.Weapon,
        equipmentFolderSprite: "axe",
        damage: 1,
        treeCut: 1),
  };
}

class ItemDB {
  String name, imgPath;
  double zoom = 1;

  //useable Effects
  int hp = 0;
  int energy = 0;
  double hungriness = 0;

  ItemType itemType = ItemType.None;
  String equipmentFolderSprite;

  //status when equip
  int damage = 0;
  int defense = 0;
  int treeCut = 0;

  ItemDB(this.name, this.imgPath, this.zoom,
      {this.hp = 0,
      this.energy = 0,
      this.hungriness = 0,
      this.itemType = ItemType.None,
      this.equipmentFolderSprite,
      this.damage = 0,
      this.defense = 0,
      this.treeCut = 0});
}

enum ItemType { None, Usable, Weapon }
