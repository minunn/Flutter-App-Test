import 'dart:async';

class ChronometerBloc {
  late Stopwatch _stopwatch;
  final _stopwatchTicker =
      Stream.periodic(Duration(milliseconds: 100)).asBroadcastStream();
  StreamController<double> _timeController = StreamController<double>();

  Stream<double> get timeStream => _timeController.stream;

  ChronometerBloc() {
    _stopwatch = Stopwatch();
  }

  void start() {
    _stopwatch.start();
    _stopwatchTicker.listen((_) {
      if (!_timeController.isClosed) {
        _timeController.add(_stopwatch.elapsedMilliseconds / 1000.0);
      }
    });
  }

  void stop() {
    _stopwatch.stop();
  }

  void reset() {
    _stopwatch.reset();
    if (!_timeController.isClosed) {
      _timeController.add(0.0);
    }
  }

  void dispose() {
    _timeController.close();
  }
}
