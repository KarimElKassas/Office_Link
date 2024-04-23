import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  static late final SharedPreferences prefs;
  static final Map<String, dynamic> memoryPrefs = {};

  static Future<SharedPreferences> load() async {
    prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  static void setString(String key, String value) {
    prefs.setString(key, value);
    memoryPrefs[key] = value;
  }
  static void setStringList(String key, List<String> value) {
    prefs.setStringList(key, value);
    memoryPrefs[key] = value;
  }
  static void setInt(String key, int value) {
    prefs.setInt(key, value);
    memoryPrefs[key] = value;
  }

  static void setDouble(String key, double value) {
    prefs.setDouble(key, value);
    memoryPrefs[key] = value;
  }

  static void setBool(String key, bool value) {
    prefs.setBool(key, value);
    memoryPrefs[key] = value;
  }

  static String? getString(String key) => memoryPrefs[key] ?? prefs.getString(key);

  static int? getInt(String key) => memoryPrefs[key] ?? prefs.getInt(key);

  static double? getDouble(String key) => memoryPrefs[key] ?? prefs.getDouble(key);

  static bool? getBool(String key) => memoryPrefs[key] ?? prefs.getBool(key);
}