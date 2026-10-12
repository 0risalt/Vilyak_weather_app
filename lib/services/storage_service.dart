import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyLastCity = 'last_city';
  static const String _keyRecentCities = 'recent_cities';
  static const int _maxRecent = 5;

  /// Сохранить последний использованный город
  Future<void> saveLastCity({
    required String name,
    required double lat,
    required double lon,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final city = {'name': name, 'lat': lat, 'lon': lon};
    await prefs.setString(_keyLastCity, jsonEncode(city));
  }

  /// Загрузить последний использованный город
  Future<Map<String, dynamic>?> loadLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyLastCity);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Добавить город в список недавних (без дублей)
  Future<void> addRecentCity({
    required String name,
    required double lat,
    required double lon,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await loadRecentCities();

    // Удаляем дубли по имени
    list.removeWhere((c) => c['name'] == name);

    // Добавляем в начало
    list.insert(0, {'name': name, 'lat': lat, 'lon': lon});

    // Обрезаем до максимума
    if (list.length > _maxRecent) {
      list.removeRange(_maxRecent, list.length);
    }

    await prefs.setString(_keyRecentCities, jsonEncode(list));
  }

  /// Загрузить список недавних городов
  Future<List<Map<String, dynamic>>> loadRecentCities() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyRecentCities);
    if (raw == null) return [];
    try {
      final List<dynamic> list = jsonDecode(raw);
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  /// Очистить недавние города
  Future<void> clearRecentCities() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRecentCities);
  }
}
