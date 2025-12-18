class Meal {
  final int? id;
  final String name;
  final DateTime dateTime;
  final int? categoryId; // Link to meal category
  // Macros
  final double? carbs; // grams
  final double? protein; // grams
  final double? fat; // grams
  final double? calories;
  // Micros (basic ones)
  final double? fiber; // grams
  final double? sugar; // grams
  final double? sodium; // mg
  final double? vitaminC; // mg
  final double? calcium; // mg
  final double? iron; // mg
  // Blood sugar correlation
  final double? bloodSugarBefore;
  final double? bloodSugarAfter;

  Meal({
    this.id,
    required this.name,
    required this.dateTime,
    this.categoryId,
    this.carbs,
    this.protein,
    this.fat,
    this.calories,
    this.fiber,
    this.sugar,
    this.sodium,
    this.vitaminC,
    this.calcium,
    this.iron,
    this.bloodSugarBefore,
    this.bloodSugarAfter,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      name: json['name'],
      dateTime: DateTime.parse(json['dateTime']),
      categoryId: json['categoryId'],
      carbs: json['carbs'] != null ? json['carbs'] as double : null,
      protein: json['protein'] != null ? json['protein'] as double : null,
      fat: json['fat'] != null ? json['fat'] as double : null,
      calories: json['calories'] != null ? json['calories'] as double : null,
      fiber: json['fiber'] != null ? json['fiber'] as double : null,
      sugar: json['sugar'] != null ? json['sugar'] as double : null,
      sodium: json['sodium'] != null ? json['sodium'] as double : null,
      vitaminC: json['vitaminC'] != null ? json['vitaminC'] as double : null,
      calcium: json['calcium'] != null ? json['calcium'] as double : null,
      iron: json['iron'] != null ? json['iron'] as double : null,
      bloodSugarBefore: json['bloodSugarBefore'] != null
          ? json['bloodSugarBefore'] as double
          : null,
      bloodSugarAfter: json['bloodSugarAfter'] != null
          ? json['bloodSugarAfter'] as double
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "dateTime": dateTime.toIso8601String(),
      "categoryId": categoryId,
      "carbs": carbs,
      "protein": protein,
      "fat": fat,
      "calories": calories,
      "fiber": fiber,
      "sugar": sugar,
      "sodium": sodium,
      "vitaminC": vitaminC,
      "calcium": calcium,
      "iron": iron,
      "bloodSugarBefore": bloodSugarBefore,
      "bloodSugarAfter": bloodSugarAfter,
    };
  }

  Meal copyWith({
    int? id,
    String? name,
    DateTime? dateTime,
    int? categoryId,
    double? carbs,
    double? protein,
    double? fat,
    double? calories,
    double? fiber,
    double? sugar,
    double? sodium,
    double? vitaminC,
    double? calcium,
    double? iron,
    double? bloodSugarBefore,
    double? bloodSugarAfter,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      dateTime: dateTime ?? this.dateTime,
      categoryId: categoryId ?? this.categoryId,
      carbs: carbs ?? this.carbs,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      calories: calories ?? this.calories,
      fiber: fiber ?? this.fiber,
      sugar: sugar ?? this.sugar,
      sodium: sodium ?? this.sodium,
      vitaminC: vitaminC ?? this.vitaminC,
      calcium: calcium ?? this.calcium,
      iron: iron ?? this.iron,
      bloodSugarBefore: bloodSugarBefore ?? this.bloodSugarBefore,
      bloodSugarAfter: bloodSugarAfter ?? this.bloodSugarAfter,
    );
  }
}
