import '../../../../hud/build/build_foundation.dart';
import '../../../../map/map_controller.dart';
import '../../../../utils/timer_helper.dart';

class FoundationDataController {
  final MapController _map;
  BuildFoundation _buildFoundation;

  FoundationDataController(this._map) {
    _buildFoundation = _map.buildFoundation;
  }

  void onFoundationEnterScreen(dynamic data) {
    var t = TimerHelper();
    print('onFoundationEnterScreen');
    data.forEach((key, value) {
      _buildFoundation.updateOrInstantiateFoundation(value);
    });
    t.logDelayPassed('onFoundationEnterScreen:');
  }
}
