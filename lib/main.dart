import 'package:flame/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';

import 'game_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
  var gameController = GameController();
  runApp(gameController.widget);

  var flameUtil = Util();
  flameUtil.fullScreen();
  flameUtil.setOrientation(DeviceOrientation.portraitUp);
}
