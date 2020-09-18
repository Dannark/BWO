class TimerHelper {
  DateTime _start;

  TimerHelper() {
    _start = DateTime.now();
  }

  void register() {
    _start = DateTime.now();
  }

  int getDelay() {
    if (_start == null) return -1;
    final diff = DateTime.now().difference(_start).inMilliseconds;
    return diff;
  }

  void logDelayPassed(String text, {int ifGreaterThan = 50}) {
    var delay = getDelay();
    if (delay >= ifGreaterThan) {
      print("\x1B[38;5;2mMethod '$text' took (${delay}ms)\x1B[0m");
    }
  }
}
