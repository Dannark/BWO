import '../../../../entity/enemys/enemy.dart';
import '../../../../entity/player/player.dart';
import '../../../../map/map_controller.dart';
import '../../../utils/server_utils.dart';

class PlayerDataController {
  final Player _player;
  final MapController _map;

  bool firstMove = true;

  PlayerDataController(this._player, this._map);

  void onPlayerEnterScreen(dynamic data) {
    Map<String, dynamic> user = data;

    user.forEach((key, value) {
      var name = value["name"].toString();
      var newX = double.parse(value['x'].toString());
      var newY = double.parse(value['y'].toString());
      var sprite = value['sprite'].toString();
      var playerId = value['playerId'].toString();

      if (name == _player.name) {
        if (firstMove == true) {
          firstMove = false;
          _player.x = newX;
          _player.y = newY;
        }
      } else {
        ServerUtils.addEntityIfNotExist(
            _map,
            Player(newX, newY, _map, name, playerId, null,
                spriteFolder: sprite, isMine: false));
      }
    });
  }

  void onAddPlayer(dynamic data) {
    Map<String, dynamic> user = data;
    var newX = double.parse(user['x'].toString());
    var newY = double.parse(user['y'].toString());

    var pName = user['name'].toString();
    var pId = user['playerId'].toString();
    var sprite = user['sprite'].toString();

    var e = Player(newX, newY, _map, pName, pId, null,
        spriteFolder: sprite, isMine: false);

    ServerUtils.addEntityIfNotExist(_map, e);
  }

  void onRemovePlayer(dynamic data) {
    var pName = data['name'].toString();

    _map.entityList.removeWhere((element) => element.name == pName);
  }

  void onPlayerUpdate(dynamic data) {
    print("onPlayerUpdate: $data");
    var hp = int.parse(data['hp'].toString(), onError: (source) => null);
    var xp = int.parse(data['xp'].toString(), onError: (source) => null);
    // var x = double.parse(data['x'].toString());
    // var y = double.parse(data['y'].toString());
    // var xSpeed = double.parse(data['xSpeed'].toString());
    // var ySpeed = double.parse(data['ySpeed'].toString());
    // var sprite = data['sprite'].toString();
    var action = data['action'].toString();

    var playerId = data['playerId'].toString();

    var foundEntity = _map.entitysOnViewport
        .firstWhere((element) => element.id == playerId, orElse: () => null);

    if (foundEntity != null) {
      hp != null ? foundEntity.status.setLife(hp) : null;
      xp != null ? foundEntity.status.setExp(xp) : null;

      if (foundEntity is Player) {
        if (action == 'reviving') {
          foundEntity.respawn();
        }
        //foundEntity.spriteFolder = sprite;
      }
    }
  }

  void onMove(dynamic data) {
    var newX = double.parse(data['x'].toString());
    var newY = double.parse(data['y'].toString());
    var xSpeed = double.parse(data['xSpeed'].toString());
    var ySpeed = double.parse(data['ySpeed'].toString());
    var sprite = data['sprite'].toString();
    var pId = data['playerId'].toString();

    var pName = data['name'].toString();

    var p = Player(newX, newY, _map, pName, pId, null,
        spriteFolder: sprite, isMine: false);
    p.xSpeed = xSpeed;
    p.ySpeed = ySpeed;

    ServerUtils.addEntityIfNotExist(_map, p, updateIfExist: true);
  }

  void onPlayerAttackEnemy(dynamic data) {
    print('onPlayerAttackEnemy, $data');

    var enemyId = data['enemyId'].toString();
    var playerId = data['playerId'].toString();
    var damage = int.parse(data['damage'].toString());
    var enemyHp = int.parse(data['enemyHp'].toString());

    var enemyEntity = _map.entitysOnViewport
        .firstWhere((element) => element.id == enemyId, orElse: () => null);
    var playerEntity = _map.entitysOnViewport
        .firstWhere((element) => element.id == playerId, orElse: () => null);

    if (enemyEntity is Enemy && playerEntity is Player) {
      playerEntity.currentSprite = playerEntity.attackSprites;

      enemyEntity.getHut(damage, playerEntity);
      enemyEntity.status.setLife(enemyHp);
    }
  }
}
