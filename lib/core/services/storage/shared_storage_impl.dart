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
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else {
      throw ArgumentError(
        'Unsupported type ${value.runtimeType} for key "$key".',
      );
    }
  }
}
