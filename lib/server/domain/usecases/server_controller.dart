import '../../../entity/player/player.dart';
import '../../../map/map_controller.dart';
import '../../../map/tree.dart';
import '../../external/datasources/socket_io_datasource.dart';
import '../../utils/server_utils.dart';
import '../repositories/server_repository.dart';
import 'entities/enemy_data_controller.dart';
import 'entities/player_data_controller.dart';

class ServerController {
  MapController map;
  Player player;

  ServerRepository _repo;
  PlayerDataController _pControl;
  EnemyDataController _eControl;

  ServerController(this.map) {
    // Choose Repository, Socket IO, Firebase etc...
    _repo = SocketIoRepository();
  }

  void setPlayer(Player player) {
    this.player = player;

    _repo.initializeClient(player, (id) {
      player.id = id;
    });

    _pControl = PlayerDataController(player, map);
    _eControl = EnemyDataController(map);

    _repo.setListener("onPlayerEnterScreen", _pControl.onPlayerEnterScreen);
    _repo.setListener("add-player", _pControl.onAddPlayer);
    _repo.setListener("remove-player", _pControl.onRemovePlayer);
    _repo.setListener("onMove", _pControl.onMove);
    _repo.setListener("onPlayerUpdate", _pControl.onPlayerUpdate);
    _repo.setListener("onPlayerAttackEnemy", _pControl.onPlayerAttackEnemy);
    _repo.setListener("onEnemysWalk", _eControl.onEnemysWalk);
    _repo.setListener("onEnemysEnterScreen", _eControl.onEnemysEnterScreen);
    _repo.setListener(
        "onEnemyTargetingPlayer", _eControl.onEnemyTargetingPlayer);
    _repo.setListener("onTreeUpdate", onTreeUpdate);
  }

  void sendMessage(String tag, dynamic jsonData) {
    _repo.sendMessage(tag, jsonData);
  }

  void movePlayer() async {
    var jsonData = {
      "name": player.name,
      "x": player.x.toInt(),
      "y": player.y.toInt(),
      "xSpeed": player.xSpeed.round(),
      "ySpeed": player.ySpeed.round()
    };
    _repo.sendMessage("onMove", jsonData);
  }

  void hitTree(int targetX, int targetY, int damage) async {
    var jsonData = {
      "name": "${player.name}",
      "targetX": targetX,
      "targetY": targetY,
      "damage": damage
    };
    _repo.sendMessage("onTreeHit", jsonData);
  }

  void attackEnemy(String targetId, String playerId) {
    var jsonData = {"enemyId": targetId, "playerId": playerId};
    _repo.sendMessage("onAttackEnemy", jsonData);
  }

  void onTreeUpdate(dynamic data) {
    print('onTreeUpdate: $data');

    data.forEach((treeId, value) {
      var x = double.parse(value['x'].toString());
      var y = double.parse(value['y'].toString());
      var playerId = value['playerId'].toString();
      var deadTime =
          int.parse(value['dead_time'].toString(), onError: (source) => null);
      var hp = int.parse(value['hp'].toString(), onError: (source) => null);
      var damage =
          int.parse(value['damage'].toString(), onError: (source) => null);

      //Make the hit attack player animation
      var foundEntity = map.entityList
          .firstWhere((element) => element.id == playerId, orElse: () => null);
      if (foundEntity != null && foundEntity is Player) {
        foundEntity.playerNetwork.hitTreeAnimation(x, y);
      }

      //Set the tree health
      var foundTree = map.entitysOnViewport
          .firstWhere((element) => element.id == treeId, orElse: () => null);
      if (foundTree != null && foundTree is Tree) {
        if (hp != null) {
          if (damage != null) {
            //take damage
            foundTree.setHealth(hp);
          } else if (hp <= 0 && deadTime > 5) {
            //immediately dies (cancel die animation)
            foundTree.disable(respawnSecTimeout: 190 - deadTime);
          } else if (hp > 0 && damage == null) {
            //respawn
            foundTree.resetTree();
          }
        }
      }
    });
  }
}
