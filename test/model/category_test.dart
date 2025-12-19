import 'package:flutter_test/flutter_test.dart';
import 'package:dracula/models/category.dart';

void main() {
  group('Category Model with Types', () {
    test('should create Category with different types', () {
      final generalCategory =
          Category(name: 'Fasting', type: CategoryType.general);
      final mealCategory = Category(name: 'Breakfast', type: CategoryType.meal);
      final workoutCategory =
          Category(name: 'Cardio', type: CategoryType.workout);

      expect(generalCategory.type, CategoryType.general);
      expect(mealCategory.type, CategoryType.meal);
      expect(workoutCategory.type, CategoryType.workout);
    });

    test('should serialize CategoryType correctly', () {
      final mealCategory = Category(
          id: 1, name: 'High Protein', type: CategoryType.meal, unit: 'g');

      final json = mealCategory.toJson();
      expect(json['type'], 'meal');

      final deserialized = Category.fromJson(json);
      expect(deserialized.type, CategoryType.meal);
    });

    test('should handle all CategoryType enum values', () {
      expect(CategoryType.values.length, 3);
      expect(CategoryType.general.index, 0);
      expect(CategoryType.meal.index, 1);
      expect(CategoryType.workout.index, 2);
    });

    test('copyWith should preserve type correctly', () {
      final original =
          Category(id: 1, name: 'Original', type: CategoryType.meal);

      final copy =
          original.copyWith(name: 'Updated', type: CategoryType.workout);

      expect(copy.name, 'Updated');
      expect(copy.type, CategoryType.workout);
      expect(copy.id, original.id);
    });
  });
}
