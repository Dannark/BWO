import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';

abstract class NetworkServer {
  final String _SERVER =
      "https://3000-e92204fd-e411-4285-8fd3-cf3515d1c358.ws-us02.gitpod.io";

  SocketIO socketIO;
  String id;
  String playerName;

  NetworkServer() {}

  void initializeServer(String playerName) {
    this.playerName = playerName;
    socketIO = SocketIOManager().createSocketIO(_SERVER, "/",
        query: "", socketStatusCallback: _socketStatus);

    socketIO.init();
    socketIO.subscribe("socket_info", _onSocketInfo);
    socketIO.subscribe("setup", onSetup);
    socketIO.subscribe("add-player", onAddPlayer);
    socketIO.subscribe("remove-player", onRemovePlayer);
    socketIO.subscribe("onMove", onMove);
    socketIO.connect();
  }

  void _socketStatus(dynamic data) {
    print("## Socket status: " + data);
  }

  void _destoryConnection() {
    if (socketIO != null) {
      SocketIOManager().destroySocket(socketIO);
    }
  }

  _onSocketInfo(dynamic data) {
    print("## Player ID: " + data);
    id = data;
    if (socketIO != null) {
      String jsonData = '{"name":"${playerName}", "x":50, "y": 0}';
      socketIO.sendMessage("log-player", jsonData, _onLogMsgSent);
    }
  }

  onSetup(dynamic data) {}

  onAddPlayer(dynamic data) {}

  onRemovePlayer(dynamic data) {}

  void onMove(dynamic data) {}

  void _onLogMsgSent(dynamic data) {}
}
