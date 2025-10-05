class Log {
  final bool activityStatus;
  final String startTime;
  final String endTime;
  final String typeOfActivity;
  final num units;
  final num activeInsulin;

  Log({
    required this.activityStatus,
    required this.startTime,
    required this.endTime,
    required this.typeOfActivity,
    required this.units,
    required this.activeInsulin,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      activityStatus: json['activity_status'] ?? false,
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      typeOfActivity: json['type_of_activity'] ?? '',
      units: json['units'] ?? 0,
      activeInsulin: json['activeinsulin'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activity_status': activityStatus,
      'start_time': startTime,
      'end_time': endTime,
      'type_of_activity': typeOfActivity,
      'units': units,
      'activeinsulin': activeInsulin,
    };
  }
}
