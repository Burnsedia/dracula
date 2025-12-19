import 'package:flutter_test/flutter_test.dart';
import 'package:dracula/models/meal.dart';

void main() {
  group('Meal Model', () {
    test('should create Meal with all fields', () {
      final dateTime = DateTime(2023, 12, 25, 12, 0);
      final meal = Meal(
        id: 1,
        name: 'Test Meal',
        dateTime: dateTime,
        carbs: 50.0,
        protein: 25.0,
        fat: 15.0,
        calories: 400.0,
        fiber: 5.0,
        sugar: 10.0,
        sodium: 500.0,
        vitaminC: 30.0,
        calcium: 200.0,
        iron: 2.0,
        bloodSugarBefore: 90.0,
        bloodSugarAfter: 120.0,
      );

      expect(meal.id, 1);
      expect(meal.name, 'Test Meal');
      expect(meal.dateTime, dateTime);
      expect(meal.carbs, 50.0);
      expect(meal.protein, 25.0);
      expect(meal.fat, 15.0);
      expect(meal.calories, 400.0);
      expect(meal.fiber, 5.0);
      expect(meal.sugar, 10.0);
      expect(meal.sodium, 500.0);
      expect(meal.vitaminC, 30.0);
      expect(meal.calcium, 200.0);
      expect(meal.iron, 2.0);
      expect(meal.bloodSugarBefore, 90.0);
      expect(meal.bloodSugarAfter, 120.0);
    });

    test('should create Meal with null optional fields', () {
      final dateTime = DateTime(2023, 12, 25, 12, 0);
      final meal = Meal(
        name: 'Simple Meal',
        dateTime: dateTime,
      );

      expect(meal.id, null);
      expect(meal.name, 'Simple Meal');
      expect(meal.dateTime, dateTime);
      expect(meal.carbs, null);
      expect(meal.protein, null);
      expect(meal.fat, null);
      expect(meal.calories, null);
      expect(meal.fiber, null);
      expect(meal.sugar, null);
      expect(meal.sodium, null);
      expect(meal.vitaminC, null);
      expect(meal.calcium, null);
      expect(meal.iron, null);
      expect(meal.bloodSugarBefore, null);
      expect(meal.bloodSugarAfter, null);
    });

    test('should serialize to JSON correctly', () {
      final dateTime = DateTime(2023, 12, 25, 12, 0);
      final meal = Meal(
        id: 1,
        name: 'Test Meal',
        dateTime: dateTime,
        carbs: 50.0,
        protein: 25.0,
        fat: 15.0,
        calories: 400.0,
        fiber: 5.0,
        sugar: 10.0,
        sodium: 500.0,
        vitaminC: 30.0,
        calcium: 200.0,
        iron: 2.0,
        bloodSugarBefore: 90.0,
        bloodSugarAfter: 120.0,
      );

      final json = meal.toJson();

      expect(json['id'], 1);
      expect(json['name'], 'Test Meal');
      expect(json['dateTime'], dateTime.toIso8601String());
      expect(json['carbs'], 50.0);
      expect(json['protein'], 25.0);
      expect(json['fat'], 15.0);
      expect(json['calories'], 400.0);
      expect(json['fiber'], 5.0);
      expect(json['sugar'], 10.0);
      expect(json['sodium'], 500.0);
      expect(json['vitaminC'], 30.0);
      expect(json['calcium'], 200.0);
      expect(json['iron'], 2.0);
      expect(json['bloodSugarBefore'], 90.0);
      expect(json['bloodSugarAfter'], 120.0);
    });

    test('should deserialize from JSON correctly', () {
      final dateTime = DateTime(2023, 12, 25, 12, 0);
      final json = {
        'id': 1,
        'name': 'Test Meal',
        'dateTime': dateTime.toIso8601String(),
        'carbs': 50.0,
        'protein': 25.0,
        'fat': 15.0,
        'calories': 400.0,
        'fiber': 5.0,
        'sugar': 10.0,
        'sodium': 500.0,
        'vitaminC': 30.0,
        'calcium': 200.0,
        'iron': 2.0,
        'bloodSugarBefore': 90.0,
        'bloodSugarAfter': 120.0,
      };

      final meal = Meal.fromJson(json);

      expect(meal.id, 1);
      expect(meal.name, 'Test Meal');
      expect(meal.dateTime, dateTime);
      expect(meal.carbs, 50.0);
      expect(meal.protein, 25.0);
      expect(meal.fat, 15.0);
      expect(meal.calories, 400.0);
      expect(meal.fiber, 5.0);
      expect(meal.sugar, 10.0);
      expect(meal.sodium, 500.0);
      expect(meal.vitaminC, 30.0);
      expect(meal.calcium, 200.0);
      expect(meal.iron, 2.0);
      expect(meal.bloodSugarBefore, 90.0);
      expect(meal.bloodSugarAfter, 120.0);
    });

    test('should handle null values in JSON deserialization', () {
      final dateTime = DateTime(2023, 12, 25, 12, 0);
      final json = {
        'name': 'Simple Meal',
        'dateTime': dateTime.toIso8601String(),
      };

      final meal = Meal.fromJson(json);

      expect(meal.id, null);
      expect(meal.name, 'Simple Meal');
      expect(meal.dateTime, dateTime);
      expect(meal.carbs, null);
      expect(meal.protein, null);
      expect(meal.fat, null);
      expect(meal.calories, null);
      expect(meal.fiber, null);
      expect(meal.sugar, null);
      expect(meal.sodium, null);
      expect(meal.vitaminC, null);
      expect(meal.calcium, null);
      expect(meal.iron, null);
      expect(meal.bloodSugarBefore, null);
      expect(meal.bloodSugarAfter, null);
    });

    test('copyWith should create new instance with updated fields', () {
      final original = Meal(
        id: 1,
        name: 'Original Meal',
        dateTime: DateTime(2023, 12, 25, 12, 0),
        carbs: 50.0,
      );

      final copy = original.copyWith(
        name: 'Updated Meal',
        protein: 25.0,
      );

      expect(copy.id, 1);
      expect(copy.name, 'Updated Meal');
      expect(copy.dateTime, original.dateTime);
      expect(copy.carbs, 50.0);
      expect(copy.protein, 25.0);
    });

    test('copyWith with no arguments should return identical copy', () {
      final original = Meal(
        id: 1,
        name: 'Test Meal',
        dateTime: DateTime(2023, 12, 25, 12, 0),
        carbs: 50.0,
      );

      final copy = original.copyWith();

      expect(copy.id, original.id);
      expect(copy.name, original.name);
      expect(copy.dateTime, original.dateTime);
      expect(copy.carbs, original.carbs);
    });
  });
}
