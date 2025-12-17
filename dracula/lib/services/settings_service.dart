import 'package:shared_preferences/shared_preferences.dart';

enum BloodSugarUnit { mgdl, mmoll }

class SettingsService {
  static const String _unitKey = 'blood_sugar_unit';
  static const String _timezoneKey = 'timezone_display';

  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  SharedPreferences? _prefs;

  Future<void> _ensureInitialized() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Blood sugar unit settings
  Future<BloodSugarUnit> getBloodSugarUnit() async {
    await _ensureInitialized();
    final unitString = _prefs!.getString(_unitKey);
    return unitString == 'mmoll' ? BloodSugarUnit.mmoll : BloodSugarUnit.mgdl;
  }

  Future<void> setBloodSugarUnit(BloodSugarUnit unit) async {
    await _ensureInitialized();
    final unitString = unit == BloodSugarUnit.mmoll ? 'mmoll' : 'mgdl';
    await _prefs!.setString(_unitKey, unitString);
  }

  // Unit conversion utilities
  double convertToDisplayUnit(double value, BloodSugarUnit unit) {
    if (unit == BloodSugarUnit.mmoll) {
      return value / 18.0; // Convert mg/dL to mmol/L
    }
    return value; // Already in mg/dL
  }

  double convertFromDisplayUnit(double value, BloodSugarUnit unit) {
    if (unit == BloodSugarUnit.mmoll) {
      return value * 18.0; // Convert mmol/L to mg/dL
    }
    return value; // Already in mg/dL
  }

  String getUnitDisplayString(BloodSugarUnit unit) {
    return unit == BloodSugarUnit.mmoll ? 'mmol/L' : 'mg/dL';
  }

  // Timezone display settings
  Future<bool> getShowTimezone() async {
    await _ensureInitialized();
    return _prefs!.getBool(_timezoneKey) ?? true;
  }

  Future<void> setShowTimezone(bool show) async {
    await _ensureInitialized();
    await _prefs!.setBool(_timezoneKey, show);
  }

  // Clear all settings (for testing)
  Future<void> clearAll() async {
    await _ensureInitialized();
    await _prefs!.clear();
  }
}