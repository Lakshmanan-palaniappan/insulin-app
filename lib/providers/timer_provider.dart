import 'package:flutter/widgets.dart';
import 'dart:async';

import 'package:insulin/services/local_database_services.dart';

class TimerProvider with ChangeNotifier {

  final int _timeToRefill = 10;

  late int _counter;
  Timer? _timer;

  TimerProvider() {
    _counter = 0;
  }

  int get counter => _counter;

  void setCounterFromDeliveredBolus(num deliveredBolus) async{
    int did = await LocalDatabaseServices().getDeviceId();
    _counter = (deliveredBolus * did==1 ? 0.15 : 0.145).round();
    if (_counter < 1) _counter = 1; // minimum 1 sec to avoid zero
    notifyListeners();
  }
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        _counter--;
        notifyListeners();
      } else {
        timer.cancel();
        _counter = 0;
        notifyListeners();
      }
    });

  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}