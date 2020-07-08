import 'dart:async';

import 'package:BWO/Entity/Entity.dart';
import 'package:BWO/Entity/Items/ItemDatabase.dart';
import 'package:BWO/Entity/Items/Items.dart';
import 'package:BWO/Entity/Player/Player.dart';
import 'package:BWO/Map/map_controller.dart';
import 'package:BWO/Server/NetworkServer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ServerController extends NetworkServer {
  DatabaseReference _players;
  StreamSubscription<Event> _counterSubscription;
  DatabaseReference _messagesRef;

  MapController map;
  Player player;
  int lastX = 0;
  int lastY = 0;

  ServerController(this.map) {
    //initFirebase();
  }

  void update() {
    if (player == null) {
      return;
    }
    if (player.posX % 10 == 0 && player.posX != lastX) {
      lastX = player.posX;
      lastY = player.posY;
      print("update viewport network chunck");
      updateStoreListener(
          Rect.fromLTWH(player.x - 300, player.y - 300, 600, 600));
    }
  }

  @override
  void onRevicedMainPlayerInfo(Player mPlayer) {
    super.onRevicedMainPlayerInfo(mPlayer);
    this.player = mPlayer;

    print("settando player instance ${player}");
  }

  @override
  void onRecivedPlayersUpdate() {
    super.onRecivedPlayersUpdate();
    for (UsersData user in usersOnScreen) {
      Entity found = map.entitysOnViewport.firstWhere(
          (element) => element.name == user.name,
          orElse: () => null);

      if (found == null) {
        print("adding Entity on screen ${user.name}");
        map.addEntity(Player(user.x, user.y, map, false, user.name));
      } else {
        if (found.name != player.name) {
          found.x = user.x;
          found.y = user.y;
        }
      }
    }
    //delete offlines ones
    map.entitysOnViewport.forEach((entityOnMap) {
      UsersData found = usersOnScreen.firstWhere(
          (element) => element.name == entityOnMap.name,
          orElse: () => null);
      if (found == null) {
        if (entityOnMap.name != player.name && entityOnMap is Player) {
          print("destroying: ${entityOnMap.name}");
          entityOnMap.destroy();
        }
      }
    });
  }

  void initFirebase() {
    print("initializing");
    _players = FirebaseDatabase.instance.reference().child('users');

    //final FirebaseDatabase database = FirebaseDatabase();
    //_messagesRef = database.reference().child('players');

    _players.keepSynced(true);
    _counterSubscription = _players.onChildChanged.listen((Event event) {
      print(event.snapshot.value);
    }, onError: (Object o) {
      final DatabaseError error = o;
      print("erro: ${error}");
    });

    /*_messagesSubscription = _messagesRef
        .orderByChild("id")
        .onChildAdded
        .listen((Event event) {
      print('Child added: ${event.snapshot.value}');
    }, onError: (Object o) {
      final DatabaseError error = o;
      print('Error: ${error.code} ${error.message}');
    });*/
  }
}
