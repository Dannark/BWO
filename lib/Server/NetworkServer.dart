import 'dart:async';

import 'package:BWO/Entity/Player/Player.dart';
import 'package:BWO/game_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class NetworkServer {
  // FireStore
  CollectionReference usersRef;
  StreamSubscription<QuerySnapshot> _messagesSubscription;

  List<UsersData> usersOnScreen = [];

  NetworkServer() {
    usersRef = Firestore.instance.collection('users');
  }

  void updateStoreListener(Rect bounds) {
    if (_messagesSubscription != null) {
      _messagesSubscription.cancel();
    }
    print("buscando... ${bounds.left} ${bounds.right}");
    _messagesSubscription = usersRef
        .where("status", isEqualTo: "online")
        .where("x",
            isGreaterThanOrEqualTo: bounds.left,
            isLessThanOrEqualTo: bounds.right)
        /*.where("y",
            isGreaterThanOrEqualTo: bounds.top,
            isLessThanOrEqualTo: bounds.bottom)*/
        .snapshots()
        .listen((data) {
      usersOnScreen.clear();
      data.documents.forEach((doc) {
        usersOnScreen
            .add(UsersData(doc.documentID, doc['status'], doc['x'], doc['y']));
      });

      onRecivedPlayersUpdate();
    });
  }

  static saveData(Map<String, dynamic> data, String documentID,
      {String collection = 'users'}) {
    Firestore.instance
        .collection(collection)
        .document(documentID)
        .setData(data);
  }

  setPlayerInitialPos(Player player) {
    Firestore.instance
        .collection('users')
        .document(player.name)
        .get()
        .then((value) {
      if (value.exists == false) {
        NetworkServer.saveData(
            {'status': 'online', 'x': player.x, 'y': player.y}, player.name);
      } else {
        player.x = value["x"];
        player.y = value["y"];

        onRevicedMainPlayerInfo(player);
        updateStoreListener(
            Rect.fromLTWH(player.x - 300, player.y - 300, 600, 600));
      }
    });
  }

  void onRevicedMainPlayerInfo(Player player) {}
  void onRecivedPlayersUpdate() {}
}

class UsersData {
  String name;
  String status;
  double x;
  double y;

  UsersData(this.name, this.status, var x, var y) {
    this.x = x.toDouble();
    this.y = y.toDouble();
  }
}
