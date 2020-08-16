import '../../../entity/player/player.dart';
import '../../../map/map_controller.dart';
import '../repositories/server_repository.dart';
import 'entities/enemy_data_controller.dart';
import 'entities/player_data_controller.dart';
import '../../external/datasources/socket_io_datasource.dart';
import '../../utils/server_utils.dart';

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
    if (ServerUtils.offlineMode) return;
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
    _repo.setListener("onEnemysWalk", _eControl.onEnemysWalk);
    _repo.setListener("onEnemysEnterScreen", _eControl.onEnemysEnterScreen);
    _repo.setListener(
        "onEnemyTargetingPlayer", _eControl.onEnemyTargetingPlayer);
  }

  void sendMessage(String tag, dynamic jsonData) {
    _repo.sendMessage(tag, jsonData);
  }

  void movePlayer() async {
    if (ServerUtils.offlineMode) return;
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
    if (ServerUtils.offlineMode) return;
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
    _repo.sendMessage("onPlayerAttackEnemy", jsonData);
  }

  void onTreeHit(dynamic data) {
    var targetX = double.parse(data['targetX'].toString());
    var targetY = double.parse(data['targetY'].toString());
    var pName = data['name'].toString();

    if (pName == player.name) {
      return;
    }
    var foundEntity = map.entityList
        .firstWhere((element) => element.name == pName, orElse: () => null);

    if (foundEntity != null && foundEntity is Player) {
      foundEntity.playerNetwork.hitTreeAnimation(targetX, targetY);
    }
  }
}
