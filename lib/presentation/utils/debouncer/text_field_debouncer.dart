import 'dart:async';
import 'dart:ui';

class TextFieldDebouncer {
  final int milliseconds;
  Function action;
  Timer? _timer;

  TextFieldDebouncer({required this.milliseconds, required this.action});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
