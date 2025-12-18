class Category {
  final int? id;
  final String name;
  final String? unit;
  final String type; // 'numeric', 'text', etc.

  Category({this.id, required this.name, this.unit, this.type = 'numeric'});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      unit: json['unit'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'unit': unit, 'type': type};
  }

  Category copyWith({int? id, String? name, String? unit, String? type}) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      type: type ?? this.type,
    );
  }
}
