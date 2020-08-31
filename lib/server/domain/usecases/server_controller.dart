import '../../../entity/player/player.dart';
import '../../../map/map_controller.dart';
import '../../external/datasources/socket_io_datasource.dart';
import '../repositories/server_repository.dart';
import 'entities/enemy_data_controller.dart';
import 'entities/foundation_data_controller.dart';
import 'entities/player_data_controller.dart';
import 'entities/tree_data_controller.dart';

class ServerController {
  MapController map;
  Player player;

  ServerRepository _repo;
  PlayerDataController _pControl;
  EnemyDataController _eControl;
  TreeDataController _tControl;
  FoundationDataController _fControl;

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
    _tControl = TreeDataController(map);
    _fControl = FoundationDataController(map);

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
    _repo.setListener("onTreeUpdate", _tControl.onTreeUpdate);
    _repo.setListener("onAddFoundation", _fControl.onFoundationEnterScreen);
  }

  void sendMessage(String tag, dynamic jsonData) async {
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

  void placeFoundation(dynamic jsonData) async {
    _repo.sendMessage("onAttackEnemy", jsonData);
  }
}
