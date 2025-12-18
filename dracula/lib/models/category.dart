enum CategoryType {
  general, // for blood sugar categories like 'fasting', 'post-meal'
  meal, // for meal categories like 'breakfast', 'high-carb'
  workout, // for workout categories like 'cardio', 'strength'
}

class Category {
  final int? id;
  final String name;
  final String? unit;
  final CategoryType type;

  Category(
      {this.id,
      required this.name,
      this.unit,
      this.type = CategoryType.general});

  factory Category.fromJson(Map<String, dynamic> json) {
    CategoryType type;
    switch (json['type']) {
      case 'meal':
        type = CategoryType.meal;
        break;
      case 'workout':
        type = CategoryType.workout;
        break;
      default:
        type = CategoryType.general;
    }

    return Category(
      id: json['id'],
      name: json['name'],
      unit: json['unit'],
      type: type,
    );
  }

  Map<String, dynamic> toJson() {
    String typeString;
    switch (type) {
      case CategoryType.meal:
        typeString = 'meal';
        break;
      case CategoryType.workout:
        typeString = 'workout';
        break;
      case CategoryType.general:
        typeString = 'general';
        break;
    }

    return {'id': id, 'name': name, 'unit': unit, 'type': typeString};
  }

  Category copyWith({int? id, String? name, String? unit, CategoryType? type}) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      type: type ?? this.type,
    );
  }
}
