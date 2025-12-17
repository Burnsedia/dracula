class ExerciseLog {
  final int? id;
  final String exerciseType;
  final int durationMinutes;
  final double? beforeBloodSugar;
  final double? afterBloodSugar;
  final DateTime createdAt;

  ExerciseLog({
    this.id,
    required this.exerciseType,
    required this.durationMinutes,
    this.beforeBloodSugar,
    this.afterBloodSugar,
    required this.createdAt,
  });

  factory ExerciseLog.fromJson(Map<String, dynamic> json) {
    return ExerciseLog(
      id: json['id'],
      exerciseType: json['exerciseType'],
      durationMinutes: json['durationMinutes'],
      beforeBloodSugar: json['beforeBloodSugar'] != null
          ? json['beforeBloodSugar'] as double
          : null,
      afterBloodSugar: json['afterBloodSugar'] != null
          ? json['afterBloodSugar'] as double
          : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "exerciseType": exerciseType,
      "durationMinutes": durationMinutes,
      "beforeBloodSugar": beforeBloodSugar,
      "afterBloodSugar": afterBloodSugar,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  ExerciseLog copyWith({
    int? id,
    String? exerciseType,
    int? durationMinutes,
    double? beforeBloodSugar,
    double? afterBloodSugar,
    DateTime? createdAt,
  }) {
    return ExerciseLog(
      id: id ?? this.id,
      exerciseType: exerciseType ?? this.exerciseType,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      beforeBloodSugar: beforeBloodSugar ?? this.beforeBloodSugar,
      afterBloodSugar: afterBloodSugar ?? this.afterBloodSugar,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
