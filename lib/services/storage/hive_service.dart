import 'package:hive/hive.dart';
import '../../core/errors/failures.dart';

class HiveService {
  static Future<void> init() async {
    // await Hive.initFlutter();
    // Register adapters here
    // await Hive.openBox('calculator_history');
    // await Hive.openBox('currency_cache');
    // await Hive.openBox('app_settings');
  }

  Future<void> storeData<T>({
    required String boxName,
    required String key,
    required T value,
  }) async {
    try {
      final box = await Hive.openBox<T>(boxName);
      await box.put(key, value);
    } catch (e) {
      throw StorageFailure('Failed to store data: $e');
    }
  }

  Future<T?> getData<T>({
    required String boxName,
    required String key,
  }) async {
    try {
      final box = await Hive.openBox<T>(boxName);
      return box.get(key);
    } catch (e) {
      throw StorageFailure('Failed to get data: $e');
    }
  }

  Future<void> deleteData({
    required String boxName,
    required String key,
  }) async {
    try {
      final box = await Hive.openBox(boxName);
      await box.delete(key);
    } catch (e) {
      throw StorageFailure('Failed to delete data: $e');
    }
  }

  Future<void> clearBox(String boxName) async {
    try {
      final box = await Hive.openBox(boxName);
      await box.clear();
    } catch (e) {
      throw StorageFailure('Failed to clear box: $e');
    }
  }
}
