class BloodSugarLog {
  final int? id;
  final double bloodSugar;
  final bool isBeforeMeal;
  final int? categoryId;
  final int? mealId;
  final DateTime createdAt;

  BloodSugarLog(
      {this.id,
      required this.bloodSugar,
      required this.isBeforeMeal,
      this.categoryId,
      this.mealId,
      required this.createdAt});

  factory BloodSugarLog.fromJson(Map<String, dynamic> json) {
    return BloodSugarLog(
      id: json['id'],
      bloodSugar: json['bloodSugar'],
      isBeforeMeal: json['isBeforeMeal'] == 1,
      categoryId: json['categoryId'],
      mealId: json['mealId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "bloodSugar": bloodSugar,
      "isBeforeMeal": isBeforeMeal ? 1 : 0,
      "categoryId": categoryId,
      "mealId": mealId,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  BloodSugarLog copyWith({
    int? id,
    double? bloodSugar,
    bool? isBeforeMeal,
    int? categoryId,
    int? mealId,
    DateTime? createdAt,
  }) {
    return BloodSugarLog(
      id: id ?? this.id,
      bloodSugar: bloodSugar ?? this.bloodSugar,
      isBeforeMeal: isBeforeMeal ?? this.isBeforeMeal,
      categoryId: categoryId ?? this.categoryId,
      mealId: mealId ?? this.mealId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
