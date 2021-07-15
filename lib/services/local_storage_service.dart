import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  final SharedPreferences _preferences;
  LocalStorageService(SharedPreferences preferences)
      : _preferences = preferences;

  void setItem(String key, String value) {
    _preferences.setString(key, value);
  }

  String getItem(String key) {
    return _preferences.getString(key) ?? "None";
  }
}
