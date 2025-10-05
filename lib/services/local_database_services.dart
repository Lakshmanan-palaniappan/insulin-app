import 'package:shared_preferences/shared_preferences.dart';

class LocalDatabaseServices {

  final String _deviceIdKey = 'device_id';
  final int _defaultDeviceId = 1;

  final String _presetBolusesKey = 'preset_bolus_list';

  final String _themeModeKey = 'is_dark_mode';

  Future<int> getDeviceId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_deviceIdKey) ?? _defaultDeviceId;
  }

  Future<void> setDeviceId(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_deviceIdKey, value);
  }

  Future<List<String>> getPresetBolusList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_presetBolusesKey) ?? [];
  }

  Future<void> savePresetBolusList(List<String> presetBolusList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(_presetBolusesKey, presetBolusList);
  }

  Future<bool> getThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeModeKey) ?? false;
  }

  Future<void> setThemeMode(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeModeKey, value);
  }
}