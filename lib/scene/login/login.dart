import 'package:flame/anchor.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../../game_controller.dart';
import '../../ui/button_ui.dart';
import '../scene_object.dart';
import 'auth.dart';
import 'auth_methods/firebase_auth.dart';

class Login extends SceneObject {
  final TextConfig _version = TextConfig(
      fontSize: 11,
      color: Color.fromRGBO(216, 165, 120, 1),
      fontFamily: "Blocktopia");
  final TextConfig _title = TextConfig(
      fontSize: 22,
      color: Color.fromRGBO(216, 165, 120, 1),
      fontFamily: "Blocktopia");
  final TextConfig _text = TextConfig(
      fontSize: 16,
      color: Color.fromRGBO(216, 165, 120, 1),
      fontFamily: "Blocktopia");
  String _versionName = "-";

  final Sprite _backPaper = Sprite("ui/backpaper1.png");

  ButtonUI _loginButton;
  AuthService _auth;

  Login() {
    _loginButton = ButtonUI(
        super.hud,
        Rect.fromLTWH(
          GameController.screenSize.width / 2,
          GameController.screenSize.height * 0.7,
          190,
          30,
        ),
        "Sign in with Google",
        padding: Rect.fromLTWH(15, 0, 0, 0),
        icon: Sprite('ui/google_sign_in.png'));

    _loginButton.onPressedListener = () {
      print('pressed');
      _auth?.login();
    };

    loadVersion().then((value) {
      _versionName = value;
      _auth = FirebaseAuth(_versionName);
    });
  }

  void draw(Canvas c) {
    super.draw(c);

    _backPaper.renderRect(c, GameController.screenSize);

    _version.render(c, "Version: $_versionName", Position(60, 50));

    _title.render(c, "> A letter from the Team of 1", Position(60, 80));
    _text.render(
      c,
      """Hello Adventures!\n
It's a pleasure to finnaly announce
this beta test release. v$_versionName!

BWO is more than just a mini project 
to me, in my eyes it is like a young 
kid that constantly needs our support 
to grow up. It not only taught me a 
lot about infrastructure CI/CD, 
performance, sockets, serverless etc, 
But also gave me the strongness to 
never give up of our dreams. If we 
can reach our goal in the time given 
than i feel like nothing is impossible
with focus and persistence.

I thanks you all for the support.
By Dannark""",
      Position(GameController.screenSize.width / 2, 120),
      anchor: Anchor.topCenter,
    );

    _loginButton.setPosition(
      Rect.fromLTWH(GameController.screenSize.width / 2,
          GameController.screenSize.height * 0.7, 190, 30),
    );
    if (_auth != null) {
      _loginButton.draw(c);
    }
  }

  Future loadVersion() async {
    var packageInfo = await PackageInfo.fromPlatform();
    var version = packageInfo.version;
    return version;
  }
}
