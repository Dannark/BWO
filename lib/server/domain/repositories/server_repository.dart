import '../../../entity/player/player.dart';

abstract class ServerRepository {
  void initializeClient(Player player, Function(String) callback);

  void setListener(String event, dynamic Function(dynamic) callback);

  void sendMessage(String tag, dynamic jsonData);
}
