import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

abstract class NetworkServer {
  //final String _SERVER = "https://3000-e92204fd-e411-4285-8fd3-cf3515d1c358.ws-us02.gitpod.io";
  final String _SERVER = "http://192.168.1.111:3000";

  Socket socket;

  String _playerName;
  String _mSprite;
  Offset _spawnPos;

  bool offlineMode = false;
  var callback;

  NetworkServer() {}

  void initializeServer(String playerName, String sprite, Offset spawnPos,
      Function(String) callback) {
    this.callback = callback;

    this._playerName = playerName;
    this._mSprite = sprite;
    this._spawnPos = spawnPos;

    socket = io(_SERVER, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false
    });
    socket.connect();

    socket.on('socket_info', onSetup);
    socket.on('onPlayerEnterScreen', onPlayerEnterScreen);
    socket.on('onEnemysWalk', onEnemysWalk);
    socket.on('onEnemysEnterScreen', onEnemysEnterScreen);
    socket.on('onEnemyTargetingPlayer', onEnemyTargetingPlayer);
    socket.on('add-player', onAddPlayer);
    socket.on("remove-player", onRemovePlayer);
    socket.on("onMove", onMove);
    socket.on("onTreeHit", onTreeHit);

    socket.on('disconnect', (_) => print('disconnected'));
    socket.on('fromServer', (_) => print(_));
  }

  void socketStatus(dynamic data) {
    print("## Socket status: " + data);
  }

  onSetup(dynamic data) {
    print("## Player ID: " + data);
    callback(data);
    if (socket.connected) {
      var jsonData = {
        "name": _playerName,
        "sprite": _mSprite,
        "x": _spawnPos.dx.toInt(),
        "y": _spawnPos.dy.toInt()
      };
      print(jsonData);
      socket.emit("log-player", jsonData);
    }
  }

  void sendMessage(String tag, var jsonData) {
    if (socket.connected) {
      socket.emit(tag, jsonData);
    } else {
      print('Not connected, fail to send message: $tag');
    }
  }

  onPlayerEnterScreen(dynamic data) {}

  onEnemysWalk(dynamic data) {}

  onEnemysEnterScreen(dynamic data) {}

  onAddPlayer(dynamic data) {}

  onRemovePlayer(dynamic data) {}

  void onMove(dynamic data) {}

  void onTreeHit(dynamic data) {}

  void onEnemyTargetingPlayer(dynamic data) {}
}
