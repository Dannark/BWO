import 'package:BWO/Entity/Player/Player.dart';
import 'package:BWO/Server/NetworkServer.dart';
import 'package:BWO/game_controller.dart';

class PlayerNetwork {
  Player player;
  int lastX = 0;
  int lastY = 0;

  double _nextSendUpdate = 0;
  double updateFrequency = 0.2;

  PlayerNetwork(this.player) {
    lastX = player.posX;
    lastY = player.posY;
  }

  void update() {
    if (GameController.time > _nextSendUpdate) {
      _nextSendUpdate = GameController.time + updateFrequency;
      if (lastX != player.x.toInt() || lastY != player.y.toInt()) {
        print("send new player pos");
        lastX = player.x.toInt();
        lastY = player.y.toInt();
        NetworkServer.saveData({
          'status': 'online',
          'x': player.x.roundToDouble(),
          'y': player.y.roundToDouble()
        }, player.name);
      }
    }
  }
}
