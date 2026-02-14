abstract class SharedStorage {
  Future<void> init();
  Future<void> set(String key, dynamic value);
  T? get<T>(String key, {T? fallback});
}
