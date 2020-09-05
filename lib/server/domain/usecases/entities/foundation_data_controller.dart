import '../../../../hud/build/build_foundation.dart';
import '../../../../map/map_controller.dart';

class FoundationDataController {
  final MapController _map;
  BuildFoundation _buildFoundation;

  FoundationDataController(this._map) {
    _buildFoundation = _map.buildFoundation;
  }

  void onFoundationEnterScreen(dynamic data) {
    //print('onFoundationEnterScreen');
    data.forEach((key, value) {
      _buildFoundation.updateOrInstantiateFoundation(value);
    });
  }
}
