enum TimingType { beforeMeal, afterMeal, beforeExercise, afterExercise, none }

class BloodSugarLog {
  final int? id;
  final double bloodSugar;
  final bool isBeforeMeal; // Keep for backward compatibility
  final TimingType timingType;
  final int? categoryId;
  final int? mealId;
  final DateTime createdAt;

  BloodSugarLog({
    this.id,
    required this.bloodSugar,
    required this.isBeforeMeal,
    TimingType? timingType,
    this.categoryId,
    this.mealId,
    required this.createdAt,
  }) : timingType = timingType ?? _migrateFromOldField(isBeforeMeal);

  static TimingType _migrateFromOldField(bool isBeforeMeal) {
    return isBeforeMeal ? TimingType.beforeMeal : TimingType.afterMeal;
  }

  factory BloodSugarLog.fromJson(Map<String, dynamic> json) {
    TimingType? timingType;
    if (json['timingType'] != null) {
      try {
        timingType = TimingType.values.firstWhere(
          (e) => e.name == json['timingType'],
        );
      } catch (e) {
        // Fallback to migration from isBeforeMeal
      }
    }

    return BloodSugarLog(
      id: json['id'],
      bloodSugar: json['bloodSugar'],
      isBeforeMeal: json['isBeforeMeal'] == 1,
      timingType: timingType,
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
      "timingType": timingType.name,
      "categoryId": categoryId,
      "mealId": mealId,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  BloodSugarLog copyWith({
    int? id,
    double? bloodSugar,
    bool? isBeforeMeal,
    TimingType? timingType,
    int? categoryId,
    int? mealId,
    DateTime? createdAt,
  }) {
    return BloodSugarLog(
      id: id ?? this.id,
      bloodSugar: bloodSugar ?? this.bloodSugar,
      isBeforeMeal: isBeforeMeal ?? this.isBeforeMeal,
      timingType: timingType,
      categoryId: categoryId ?? this.categoryId,
      mealId: mealId ?? this.mealId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
