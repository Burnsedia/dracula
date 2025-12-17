import 'package:flutter_test/flutter_test.dart';
import 'package:dracula/models/bloodsugar.dart';

void main() {
  group('BloodSugarLog', () {
    final testDate = DateTime(2023, 10, 1, 12, 0, 0);

    test('fromJson creates a valid BloodSugarLog object', () {
      final json = {
        'id': 1,
        'bloodSugar': 120.0,
        'isBeforeMeal': true,
        'createdAt': testDate.toIso8601String(),
      };
      final log = BloodSugarLog.fromJson(json);
      expect(log.id, 1);
      expect(log.bloodSugar, 120.0);
      expect(log.isBeforeMeal, true);
      expect(log.createdAt, testDate);
    });

    test('toJson creates a valid JSON map', () {
      final log = BloodSugarLog(
        id: 1,
        bloodSugar: 120.0,
        isBeforeMeal: true,
        createdAt: testDate,
      );
      final json = log.toJson();
      expect(json['id'], 1);
      expect(json['bloodSugar'], 120.0);
      expect(json['isBeforeMeal'], true);
      expect(json['createdAt'], testDate.toIso8601String());
    });

    test('copyWith creates a new instance with updated fields', () {
      final original = BloodSugarLog(
        id: 1,
        bloodSugar: 120.0,
        isBeforeMeal: true,
        createdAt: testDate,
      );

      final copied = original.copyWith(bloodSugar: 130.0, isBeforeMeal: false);

      expect(copied.id, 1);
      expect(copied.bloodSugar, 130.0);
      expect(copied.isBeforeMeal, false);
      expect(copied.createdAt, testDate);

      // Original should be unchanged
      expect(original.bloodSugar, 120.0);
      expect(original.isBeforeMeal, true);
    });

    test('copyWith with null id creates instance with null id', () {
      final log = BloodSugarLog(
        bloodSugar: 120.0,
        isBeforeMeal: true,
        createdAt: testDate,
      );
      expect(log.id, null);
    });
  });
}
