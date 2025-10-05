import 'package:firebase_database/firebase_database.dart';

import 'package:insulin/models/insulin_data.dart';

import '../models/Log.dart';

class FirebaseServices {
  DatabaseReference database = FirebaseDatabase.instance.ref();

  Stream<InsulinData> insulinDataStream(int deviceId) {
    return database.child('$deviceId').onValue.map((DatabaseEvent event) {
      print("firebase listening");
      if (event.snapshot.exists) {
        return InsulinData.fromSnapshot(event.snapshot.value);
      } else {
        return InsulinData.placeHolder();
      }
    });
  }

  Stream<bool> isloading(int deviceId) {
    return database.child('$deviceId').onValue.map((DatabaseEvent event) {
      if (event.snapshot.exists) {
        return InsulinData.fromSnapshot(event.snapshot.value).isDelivering==0 ? false : true;
      } else {
        return false;
      }
    });
  }

  Stream<bool> isrewining(int deviceId) {
    return database.child('$deviceId').onValue.map((DatabaseEvent event) {
      if (event.snapshot.exists) {
        return InsulinData.fromSnapshot(event.snapshot.value).isrewinding==0 ? false : true;
      } else {
        return false;
      }
    });
  }

  Future<void> updateInsulinData(int deviceId, InsulinData? insulinData,) async {
    await database.child('$deviceId').update(insulinData!.toJson());
  }
  Future<List<Log>> getBasalLogs(int deviceId) async {
    DatabaseReference ref = database.child('$deviceId').child('log');
    DataSnapshot snapshot = await ref.get();

    if (!snapshot.exists || snapshot.value == null) {
      return [];
    }

    final rawData = snapshot.value;
    List<Log> logs = [];

    bool isRelevant(String? type) {
      return type == 'Bolus' || type == 'Rewind' || type == 'Custom Refill' || true;
    }

    if (rawData is Map) {
      rawData.forEach((key, value) {
        if (value is Map) {
          final log = Log.fromJson(Map<String, dynamic>.from(value));
          if (isRelevant(log.typeOfActivity) ) {
            logs.add(log);
          }
        }
      });
    } else if (rawData is List) {
      for (final item in rawData) {
        if (item is Map) {
          final log = Log.fromJson(Map<String, dynamic>.from(item));
          if (isRelevant(log.typeOfActivity)) {
            logs.add(log);
          }
        }
      }
    } else if (rawData is Map<String, dynamic>) {
      final log = Log.fromJson(rawData);
      if (isRelevant(log.typeOfActivity)) {
        logs.add(log);
      }
    }
    return logs;
  }

  Future<List<Log>> getActivityLogs(int deviceId) async {
    DatabaseReference ref = database.child('$deviceId').child('log');
    DataSnapshot snapshot = await ref.get();

    if (snapshot.exists && snapshot.value != null) {
      List<Log> logs = [];

      final data = snapshot.value;

      if (data is Map) {
        data.forEach((key, value) {
          if (value != null) {
            logs.add(Log.fromJson(Map<String, dynamic>.from(value)));
          }
        });
      } else if (data is List) {
        for (var item in data) {
          if (item != null) {
            logs.add(Log.fromJson(Map<String, dynamic>.from(item)));
          }
        }
      } else if (data is Map<String, dynamic>) {
        logs.add(Log.fromJson(data));
      }

      return logs;
    } else {
      return [];
    }
  }

}
