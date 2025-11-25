import 'package:flutter_test/flutter_test.dart';
import 'package:dracula/models/bloodsugar.dart';

void main() {
  group('BloodSugarLog', () {
    test('fromJson creates a valid BloodSugarLog object', () {
      final json = {
        'bloodSugar': 120.0,
        'isBeforeMeal': true,
        'createdAt': DateTime.now().toIso8601String(),
      };
      final log = BloodSugarLog.fromJson(json);
      expect(log.bloodSugar, 120.0);
      expect(log.isBeforeMeal, true);
      expect(log.createdAt, isA<DateTime>());
    });

    test('toJson creates a valid JSON map', () {
      final log = BloodSugarLog(
        bloodSugar: 120.0,
        isBeforeMeal: true,
        createdAt: DateTime.now(),
      );
      final json = log.toJson();
      expect(json['bloodSugar'], 120.0);
      expect(json['isBeforeMeal'], true);
      expect(json['createdAt'], isA<DateTime>());
    });
  });
}
