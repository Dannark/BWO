import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../game_controller.dart';
import '../../../server/utils/server_utils.dart';
import '../../../utils/toast_message.dart';
import '../../character_creation/character_creation.dart';
import '../../game_scene.dart';
import '../auth.dart';

class FirebaseAuth implements AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );
  FirebaseFirestore firestore;

  CollectionReference usersCollection;
  GoogleSignInAccount mAccount;

  String appVersion;

  FirebaseAuth(this.appVersion) {
    _googleSignIn.onCurrentUserChanged.listen((var account) {
      print('account $account');
      mAccount = account;

      _getVersionNumber();
    });
    _googleSignIn.signInSilently(); //auto login
    //logout(); // force login
  }

  Future<void> _handleSignIn() async {
    _googleSignIn.isSignedIn().then((isLogged) {
      try {
        _googleSignIn.signIn();
      } on Exception catch (error) {
        print(error);
      }

      // print('You are already logged in, welcome ${mAccount?.displayName}');
      // _getVersionNumber();
    });
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  void login() {
    _handleSignIn();
  }

  void logout() {
    _handleSignOut();
  }

  void _getVersionNumber() async {
    var data = FirebaseDatabase.instance.reference().child('version');

    data.once().then((snapshot) {
      if (snapshot.value == appVersion) {
        _createOrReplaceAndLogUser();
      } else {
        Toast.add("You are out of date. The new version is: ${snapshot.value}");
        logout();
      }
    });
  }

  //firebase
  void _createOrReplaceAndLogUser() async {
    await Firebase.initializeApp();

    firestore = FirebaseFirestore.instance;
    usersCollection = firestore.collection('users');

    var user = {
      "id": mAccount.id,
      "displayName": mAccount.displayName,
      "email": mAccount.email,
      "photoUrl": mAccount.photoUrl
    };
    await usersCollection.doc(user["id"]).set(user, SetOptions(merge: true));

    //checks if user account has a character already
    await getCharacterNameFromUserAccount().then((charName) {
      print('playing with character $charName');
      if (charName != null) {
        retriveCharacterData(charName);
      } else {
        print('No characters found, moving to '
            'character creation windows.');
        GameController.currentScene = CharacterCreation(this);
      }
    });
  }

  void retriveCharacterData(String characterName) async {
    var data = FirebaseDatabase.instance
        .reference()
        .child('${ServerUtils.database}/state/players/$characterName');

    data.once().then((snapshot) {
      if (snapshot.value != null) {
        print('Retrieved character information: ${snapshot.value}');

        var pName = snapshot.value['name'];
        var pX = double.parse(snapshot.value['x'].toString());
        var pY = double.parse(snapshot.value['y'].toString());
        var pSprite = snapshot.value['sprite'];
        var pHp = int.parse(snapshot.value['hp'].toString());
        var pXp = int.parse(snapshot.value['xp'].toString());
        var pLv = int.parse(snapshot.value['lv'].toString());

        print('creating player $pName on position: $pX, $pY');

        GameController.currentScene =
            GameScene(pName, Offset(pX, pY), pSprite, pHp, pXp, pLv);
      } else {
        print('Character not found, moving to character creation windows.');
        GameController.currentScene = CharacterCreation(this);
      }
    });
  }

  Future<bool> isNameAvailable(String characterName) async {
    var data = FirebaseDatabase.instance
        .reference()
        .child('${ServerUtils.database}/state/players/$characterName');

    var isAvaiable = false;

    await data.once().then((snapshot) {
      if (snapshot.value == null) {
        isAvaiable = true;
      } else {
        Toast.add('Character name already taken: ${snapshot.value["name"]}');
      }
    });
    return isAvaiable;
  }

  Future createCharacterForUser(String characterName) async {
    print('saving character name: $characterName to account: ${mAccount.id}');
    var user = {
      "id": mAccount.id,
      "characterName": characterName,
    };

    await usersCollection.doc(user["id"]).set(user, SetOptions(merge: true));
  }

  Future<String> getCharacterNameFromUserAccount() async {
    //checks if user account has a character already

    var charName = await usersCollection.doc(mAccount.id).get().then((value) {
      var data = value.data();
      if (data.containsKey('characterName')) {
        var charName = value.get('characterName');
        return charName;
      }
      return null;
    });
    return charName;
  }
}
