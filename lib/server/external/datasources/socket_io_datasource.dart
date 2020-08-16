import 'package:socket_io_client/socket_io_client.dart';

import '../../../entity/player/player.dart';
import '../../domain/repositories/server_repository.dart';
import '../../utils/server_utils.dart';

class SocketIoRepository implements ServerRepository {
  Socket socket;
  Player _player;

  Function(String) callback;

  void initializeClient(Player player, Function(String) callback) {
    this.callback = callback;

    _player = player;

    socket = io(ServerUtils.server, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false
    });
    socket.connect();

    socket.on('onSetup', onSetup);

    /*socket.on('onPlayerEnterScreen', onPlayerEnterScreen);
    socket.on('add-player', onAddPlayer);
    socket.on("remove-player", onRemovePlayer);
    socket.on("onMove", onMove);
    socket.on("onPlayerUpdate", onPlayerUpdate);
    socket.on('onEnemysWalk', onEnemysWalk);
    socket.on('onEnemysEnterScreen', onEnemysEnterScreen);
    socket.on('onEnemyTargetingPlayer', onEnemyTargetingPlayer);
    socket.on("onTreeHit", onTreeHit);*/

    socket.on('disconnect', (_) => print('disconnected'));
  }

  void setListener(String event, dynamic Function(dynamic) callback) {
    socket.on(event, callback);
  }

  void socketStatus(dynamic data) {
    print("## Socket status: $data");
  }

  void onSetup(dynamic data) {
    print("## Player ID: $data");
    callback(data);
    if (socket.connected) {
      var jsonData = {
        "name": _player.name,
        "sprite": _player.spriteFolder,
        "x": _player.x,
        "y": _player.y,
        "hp": _player.status.getHP(),
      };
      print(jsonData);
      socket.emit("log-player", jsonData);
    }
  }

  void sendMessage(String tag, dynamic jsonData) {
    if (socket.connected) {
      socket.emit(tag, jsonData);
    } else {
      print('Not connected, fail to send message: $tag');
    }
  }

  void onPlayerEnterScreen(dynamic data) {
    print("onPlayerEnterScreen $data");
  }

  void onEnemysWalk(dynamic data) {
    //print("onEnemysWalk ${data}");
  }

  void onEnemysEnterScreen(dynamic data) {
    //print("onEnemysEnterScreen ${data}");
  }

  void onAddPlayer(dynamic data) {
    print("onAddPlayer $data");
  }

  void onRemovePlayer(dynamic data) {
    print("onRemovePlayer $data");
  }

  void onMove(dynamic data) {
    print("onMove $data");
  }

  void onPlayerUpdate(dynamic data) {
    print("onPlayerUpdate $data");
  }

  void onTreeHit(dynamic data) {
    print("onTreeHit $data");
  }

  void onEnemyTargetingPlayer(dynamic data) {
    print("onEnemyTargetingPlayer $data");
  }
}
