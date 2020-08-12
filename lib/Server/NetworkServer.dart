import 'dart:convert';

import 'package:BWO/Entity/Player/Player.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

abstract class NetworkServer {
  //final String _SERVER = "https://3000-e92204fd-e411-4285-8fd3-cf3515d1c358.ws-us02.gitpod.io";
  final String _SERVER = "http://192.168.1.111:3000";

  Socket socket;
  Player _player;

  bool offlineMode = false;
  var callback;

  NetworkServer() {}

  void initializeClient(Player player, Function(String) callback) {
    this.callback = callback;

    this._player = player;

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
    socket.on("onPlayerUpdate", onPlayerUpdate);
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

  void sendMessage(String tag, var jsonData) {
    if (socket.connected) {
      socket.emit(tag, jsonData);
    } else {
      print('Not connected, fail to send message: $tag');
    }
  }

  onPlayerEnterScreen(dynamic data) {
    //print("onPlayerEnterScreen ${data}");
  }

  onEnemysWalk(dynamic data) {
    //print("onEnemysWalk ${data}");
  }

  onEnemysEnterScreen(dynamic data) {
    //print("onEnemysEnterScreen ${data}");
  }

  onAddPlayer(dynamic data) {
    print("onAddPlayer ${data}");
  }

  onRemovePlayer(dynamic data) {
    print("onRemovePlayer ${data}");
  }

  void onMove(dynamic data) {
    print("onMove ${data}");
  }

  void onPlayerUpdate(dynamic data) {
    print("onPlayerUpdate ${data}");
  }

  void onTreeHit(dynamic data) {
    print("onTreeHit ${data}");
  }

  void onEnemyTargetingPlayer(dynamic data) {
    print("onEnemyTargetingPlayer ${data}");
  }
}
