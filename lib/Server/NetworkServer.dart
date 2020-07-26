import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';

abstract class NetworkServer {
  final String _SERVER =
      "https://3000-e92204fd-e411-4285-8fd3-cf3515d1c358.ws-us02.gitpod.io";

  SocketIO socketIO;
  String id;
  String playerName;
  String mSprite;

  bool offlineMode = false;

  NetworkServer() {}

  void initializeServer(String playerName, String sprite) {
    this.playerName = playerName;
    this.mSprite = sprite;

    if (offlineMode) return;
    socketIO = SocketIOManager().createSocketIO(_SERVER, "/",
        query: "", socketStatusCallback: socketStatus);

    socketIO.init();
    socketIO.subscribe("socket_info", _onSocketInfo);
    socketIO.subscribe("getPlayers", getPlayers);
    socketIO.subscribe("getEnemys", getEnemys);
    socketIO.subscribe("add-player", onAddPlayer);
    socketIO.subscribe("remove-player", onRemovePlayer);
    socketIO.subscribe("onMove", onMove);
    socketIO.subscribe("onActionAll", onActionAll);
    socketIO.connect();
  }

  void socketStatus(dynamic data) {
    //print("## Socket status: " + data);
  }

  void _destoryConnection() {
    if (socketIO != null) {
      print("## Login out ");
      SocketIOManager().destroySocket(socketIO);
    }
  }

  _onSocketInfo(dynamic data) {
    print("## Player ID: " + data);
    id = data;
    if (socketIO != null) {
      String jsonData =
          '{"name":"${playerName}", "sprite":"$mSprite", "x":50, "y": 0}';
      socketIO.sendMessage("log-player", jsonData, _onLogMsgSent);
    }
  }

  getPlayers(dynamic data) {}

  getEnemys(dynamic data) {}

  onAddPlayer(dynamic data) {}

  onRemovePlayer(dynamic data) {}

  void onMove(dynamic data) {}

  void onActionAll(dynamic data) {}

  void _onLogMsgSent(dynamic data) {}
}
