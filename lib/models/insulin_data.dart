class InsulinData {
  final num activeInsulin;
  final num basalRate;
  final num bolus;
  final num deliveredBolus;
  final int refill;
  final num refillval;
  final int tillTip;
  final bool isActive;
  final int isDelivering;
  final int wifistatus;
  final int isrewinding;
  final int timerewind;

  InsulinData({
    required this.activeInsulin,
    required this.basalRate,
    required this.bolus,
    required this.deliveredBolus,
    required this.refill,
    required this.refillval,
    required this.tillTip,
    required this.isActive,
    required this.isDelivering,
    required this.wifistatus,
    required this.isrewinding,
    required this.timerewind,
  });

  factory InsulinData.fromJson(Map<String, dynamic> json) {
    return InsulinData(
      activeInsulin: json['activeinsulin'] ?? 0,
      basalRate: json['basalRate'] ?? 0,
      bolus: json['bolus'] ?? 0,
      deliveredBolus: json['deliveredBolus'] ?? 0,
      refill: json['refill'] ?? 0,
      refillval: json['refillval'] ?? 0,
      tillTip: json['tilltip'] ?? 0,
      isActive: json['active'] ?? false,
      isDelivering: json['isDelivering'] ?? 0,
      wifistatus: json['wifistatus'] ?? 0,
      isrewinding: json['isrewinding'] ?? 0,
      timerewind: json['timerewind'] ?? 0,
    );
  }

  factory InsulinData.placeHolder() {
    return InsulinData(
      activeInsulin: 0,
      basalRate: 0,
      bolus: 0,
      deliveredBolus: 0,
      refill: 0,
      refillval: 0,
      tillTip: 0,
      isActive: false,
      isDelivering: 0,
      wifistatus: 0,
      isrewinding: 0,
      timerewind: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activeinsulin': activeInsulin,
      'basalRate': basalRate,
      'bolus': bolus,
      'deliveredBolus': deliveredBolus,
      'refill': refill,
      'refillval': refillval,
      'tilltip': tillTip,
      'active': isActive,
      'isDelivering': isDelivering,
      'wifistatus': wifistatus,
      'isrewinding': isrewinding,
      'timerewind': timerewind,
    };
  }

  InsulinData copyWith({
    num? activeInsulin,
    num? basalRate,
    num? bolus,
    num? deliveredBolus,
    int? refill,
    double? refillval,
    int? tillTip,
    bool? isActive,
    int? isDelivering,
    int? wifistatus,
    int? isrewind,
    int? timerewind,
  }) {
    return InsulinData(
      activeInsulin: activeInsulin ?? this.activeInsulin,
      basalRate: basalRate ?? this.basalRate,
      bolus: bolus ?? this.bolus,
      deliveredBolus: deliveredBolus ?? this.deliveredBolus,
      refill: refill ?? this.refill,
      refillval: refillval ?? this.refillval,
      tillTip: tillTip ?? this.tillTip,
      isActive: isActive ?? this.isActive,
      isDelivering: isDelivering ?? this.isDelivering,
      wifistatus: wifistatus ?? this.wifistatus,
      isrewinding: isrewind ?? this.isrewinding,
      timerewind: timerewind ?? this.timerewind,
    );
  }

  static InsulinData fromSnapshot(dynamic snapshot) {
    if (snapshot is Map) {
      return InsulinData.fromJson(Map<String, dynamic>.from(snapshot));
    } else {
      throw Exception("Invalid snapshot format");
    }
  }
}
