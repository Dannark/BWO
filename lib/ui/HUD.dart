import 'package:flutter/material.dart';

import '../utils/timer_helper.dart';
import 'ui_element.dart';

class HUD {
  bool isActive = true;
  List<UIElement> uiElelements = [];
  List<UIElement> uiElelementToBeAdded = [];

  HUD();

  void draw(Canvas c) {
    if (!isActive) {
      return;
    }
    var t = TimerHelper();

    for (var ui in uiElelements) {
      if (ui.drawOnHUD) {
        ui.draw(c);
      }
    }

    _addNewElementsOnSafity();
    t.logDelayPassed('HUD: (${uiElelements.length})');
  }

  void addElement(UIElement newUi) {
    newUi.hudRef = this;
    uiElelementToBeAdded.add(newUi);
  }

  /// Only add elements after all elements on has been drawn
  _addNewElementsOnSafity() {
    for (var newUI in uiElelementToBeAdded) {
      uiElelements.add(newUI);
    }
    uiElelementToBeAdded.clear();
  }
}
