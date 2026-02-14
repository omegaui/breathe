import 'package:breathe/core/services/storage/shared_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedStorageImpl extends SharedStorage {
  late SharedPreferences prefs;

  @override
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  T? get<T>(String key, {T? fallback}) {
    final savedValue = prefs.get(key);
    return savedValue != null ? savedValue as T : fallback;
  }

  @override
  Future<void> set(String key, dynamic value) async {
    if (value.runtimeType == String) {
      prefs.setString(key, value);
    } else if (value.runtimeType == int) {
      prefs.setInt(key, value);
    } else if (value.runtimeType == double) {
      prefs.setDouble(key, value);
    } else if (value.runtimeType == bool) {
      prefs.setBool(key, value);
    } else {
      throw Exception(
        "Unknown ${value.runtimeType} encountred, cannot save $key.",
      );
    }
  }
}
