class BloodSugarLog {
  final int? id;
  final double bloodSugar;
  final bool isBeforeMeal;
  final DateTime createdAt;

  BloodSugarLog(
      {this.id,
      required this.bloodSugar,
      required this.isBeforeMeal,
      required this.createdAt});

  factory BloodSugarLog.fromJson(Map<String, dynamic> json) {
    return BloodSugarLog(
      id: json['id'],
      bloodSugar: json['bloodSugar'],
      isBeforeMeal: json['isBeforeMeal'] == 1,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "bloodSugar": bloodSugar,
      "isBeforeMeal": isBeforeMeal ? 1 : 0,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  BloodSugarLog copyWith({
    int? id,
    double? bloodSugar,
    bool? isBeforeMeal,
    DateTime? createdAt,
  }) {
    return BloodSugarLog(
      id: id ?? this.id,
      bloodSugar: bloodSugar ?? this.bloodSugar,
      isBeforeMeal: isBeforeMeal ?? this.isBeforeMeal,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
