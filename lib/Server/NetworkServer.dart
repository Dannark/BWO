import 'package:flutter/cupertino.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';

abstract class NetworkServer {
  final String _SERVER =
      "https://3000-e92204fd-e411-4285-8fd3-cf3515d1c358.ws-us02.gitpod.io";

  SocketIO socketIO;
  String id;
  String playerName;
  String mSprite;
  Offset spawnPos;

  bool offlineMode = false;
  var callback;

  NetworkServer() {}

  void initializeServer(String playerName, String sprite, Offset spawnPos,
      Function(String) callback) {
    this.callback = callback;

    this.playerName = playerName;
    this.mSprite = sprite;
    this.spawnPos = spawnPos;

    socketIO = SocketIOManager().createSocketIO(_SERVER, "/",
        query: "", socketStatusCallback: socketStatus);

    socketIO.init();
    socketIO.subscribe("socket_info", onSetup);
    socketIO.subscribe("getPlayersOnScreen", getPlayersOnScreen);
    socketIO.subscribe("getEnemys", getEnemys);
    socketIO.subscribe("getAllEnemysOnScreen", getAllEnemysOnScreen);
    socketIO.subscribe("onEnemyTargetingPlayer", onEnemyTargetingPlayer);
    socketIO.subscribe("add-player", onAddPlayer);
    socketIO.subscribe("remove-player", onRemovePlayer);
    socketIO.subscribe("onMove", onMove);
    socketIO.subscribe("onTreeHit", onTreeHit);
    socketIO.connect();
  }

  void socketStatus(dynamic data) {
    //print("## Socket status: " + data);
  }

  void destoryConnection() {
    if (socketIO != null) {
      print("## Login out ");
      SocketIOManager().destroySocket(socketIO);
    }
  }

  onSetup(dynamic data) {
    print("## Player ID: " + data);
    id = data;
    callback(data);
    if (socketIO != null) {
      String jsonData =
          '{"name":"${playerName}", "sprite":"$mSprite", "x":${spawnPos.dx.toInt()}, "y": ${spawnPos.dy.toInt()}}';
      socketIO.sendMessage("log-player", jsonData, _onLogMsgSent);
    }
  }

  getPlayersOnScreen(dynamic data) {}

  getEnemys(dynamic data) {}

  getAllEnemysOnScreen(dynamic data) {}

  onAddPlayer(dynamic data) {}

  onRemovePlayer(dynamic data) {}

  void onMove(dynamic data) {}

  void onTreeHit(dynamic data) {}

  void onEnemyTargetingPlayer(dynamic data) {}

  void _onLogMsgSent(dynamic data) {}
}
