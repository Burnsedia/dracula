class BloodSugarLog {
  final double bloodSugar;
  final bool isBeforeMeal;
  final DateTime createdAt;


  BloodSugarLog({
    required this.bloodSugar,
    required this.isBeforeMeal,
    required this.createdAt
  });

  factory BloodSugarLog.fromJson(Map<String, dynamic> json){
    return BloodSugarLog(
      bloodSugar: json['bloodSugar'],
      isBeforeMeal: json['isBeforeMeal'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "bloodSugar": bloodSugar,
      "isBeforeMeal": isBeforeMeal,
      "createdAt": createdAt,
    }
  }
}


