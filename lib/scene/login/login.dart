import 'package:flame/sprite.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';

import '../../game_controller.dart';
import '../../ui/button_ui.dart';
import '../scene_object.dart';
import 'auth.dart';
import 'auth_methods/firebase_auth.dart';

class Login extends SceneObject {
  final Paint _p = Paint();

  final TextConfig _title = TextConfig(
      fontSize: 22.0,
      color: Color.fromRGBO(216, 165, 120, 1),
      fontFamily: "Blocktopia");

  final Sprite _backPaper = Sprite("ui/backpaper1.png");

  ButtonUI _loginButton;
  AuthService _auth;

  Login() {
    _auth = FirebaseAuth();

    _loginButton = ButtonUI(
      super.hud,
      Rect.fromLTWH(
        GameController.screenSize.width / 2,
        GameController.screenSize.height * 0.77,
        100,
        30,
      ),
      "Login",
    );

    _loginButton.onPressedListener = () {
      print('pressed');
      _auth.login();
    };
  }

  void draw(Canvas c) {
    super.draw(c);

    _backPaper.renderRect(c, GameController.screenSize);

    _loginButton.setPosition(
      Rect.fromLTWH(GameController.screenSize.width / 2,
          GameController.screenSize.height * 0.77, 100, 30),
    );
    _loginButton.draw(c);
  }
}
