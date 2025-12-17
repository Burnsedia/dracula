import 'package:flutter_test/flutter_test.dart';
import 'package:dracula/models/bloodsugar.dart';

void main() {
  group('BloodSugarLog', () {
    test('fromJson creates a valid BloodSugarLog object', () {
      final now = DateTime.now();
      final json = {
        'bloodSugar': 120.0,
        'isBeforeMeal': 1,
        'createdAt': now.toIso8601String(),
      };
      final log = BloodSugarLog.fromJson(json);

      expect(log.bloodSugar, 120.0);
      expect(log.isBeforeMeal, true);
      expect(log.createdAt, now);
    });

    test('toJson creates a valid JSON map', () {
      final now = DateTime.now();
      final log = BloodSugarLog(
        bloodSugar: 120.0,
        isBeforeMeal: true,
        createdAt: now,
      );
      final json = log.toJson();

      expect(json['bloodSugar'], 120.0);
      expect(json['isBeforeMeal'], 1);
      expect(json['createdAt'], now.toIso8601String());
    });
  });
}
