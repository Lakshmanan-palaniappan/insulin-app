import 'package:flutter/widgets.dart';
import 'package:insulin/models/Log.dart';
import 'dart:async';

import 'package:insulin/models/insulin_data.dart';
import 'package:insulin/services/firebase_services.dart';
import 'package:insulin/services/local_database_services.dart';


class InsulinProvider extends ChangeNotifier {
  // Getters
  InsulinData? _insulinData;
  InsulinData? get insulinData => _insulinData;

  int _deviceID = 1;
  int get deviceId => _deviceID;

  // Service Providers
  final FirebaseServices _firebaseServices = FirebaseServices();
  final LocalDatabaseServices _localDatabaseServices = LocalDatabaseServices();

  late StreamSubscription<InsulinData> _subscription;

  // Initializer
  Future<void> initialize() async {
    await loadDeviceId();
    streamInsulinData();
  }

  // Business Logic Methods
  void changeBasalRate(num basalRate) {
    _insulinData = _insulinData!.copyWith(basalRate: basalRate);
    notifyListeners();
  }

  void changeBolusDosage(num bolus) {
    _insulinData = _insulinData!.copyWith(bolus: bolus);
    notifyListeners();
  }

  // Local Storage Methods
  Future<void> loadDeviceId() async {
    _deviceID = await _localDatabaseServices.getDeviceId();
  }

  Future<void> updateDeviceId(int newDeviceId) async {
    if (newDeviceId != _deviceID) {
      await _localDatabaseServices.setDeviceId(newDeviceId);
      _deviceID = newDeviceId;
      resetStream();
    }
  }
  
  // Firebase Methods
  void streamInsulinData() {
    _subscription =
        _firebaseServices.insulinDataStream(_deviceID).listen((data) {
      _insulinData = data;
      notifyListeners();
    });
  }

  void resetStream() {
    _subscription.cancel();
    streamInsulinData();
  }

  void updateInsulinLevel(num insulinLevel) {
    _insulinData = _insulinData!.copyWith(activeInsulin: insulinLevel);
    _firebaseServices.updateInsulinData(_deviceID, _insulinData);
  }

  void turnOnTillTip() {
    _insulinData = _insulinData!.copyWith(tillTip: 50);
    _firebaseServices.updateInsulinData(_deviceID, _insulinData);
  }

  void turnOnManRewind() {
    _insulinData = _insulinData!.copyWith(timerewind: 50,isrewind: 1);
    _firebaseServices.updateInsulinData(_deviceID, _insulinData);
  }

  void turnOnRefill() {
    _insulinData = _insulinData!.copyWith(refill: 50);
    _firebaseServices.updateInsulinData(_deviceID, _insulinData);
  }

  void turnOnRewind(double refillval) {
    _insulinData = _insulinData!.copyWith(refillval: refillval);
    _firebaseServices.updateInsulinData(_deviceID, _insulinData);
  }

  void saveBasalRate(num basalRate) {
    _insulinData = _insulinData!.copyWith(basalRate: basalRate);
    _firebaseServices.updateInsulinData(_deviceID, _insulinData);
  }

  void saveBolusDosage(num bolus) {
    _insulinData = _insulinData!.copyWith(bolus: bolus,isDelivering: 1);
    _firebaseServices.updateInsulinData(_deviceID, _insulinData);
  }

  void pingIsActive() {
    _insulinData = _insulinData!.copyWith(wifistatus: 0);
    _firebaseServices.updateInsulinData(_deviceID, _insulinData);
  }

  Future<List<Log>> getBasalLogs() => FirebaseServices().getBasalLogs(deviceId);
  Future<List<Log>> getActivityLogs() => FirebaseServices().getActivityLogs(deviceId);
  Stream<bool> isloading() => FirebaseServices().isloading(deviceId);
  Stream<bool> isrewinding() => FirebaseServices().isrewining(deviceId);

}
