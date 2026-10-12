import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather_model.dart';

class WeatherApi {
  // ⚠️ Вставь сюда свой ключ OpenWeatherMap
  static const String _apiKey = '3e783e9169e729953a561d2e02e159b6';

  static const String _baseUrl = 'https://api.openweathermap.org';
  static const String _lang = 'ru';
  static const String _units = 'metric';

  /// Текущая погода по координатам
  Future<CurrentWeatherResponse> getCurrentWeather(
    double lat,
    double lon,
  ) async {
    final uri = Uri.parse(
      '$_baseUrl/data/2.5/weather'
      '?lat=$lat&lon=$lon'
      '&units=$_units&lang=$_lang&appid=$_apiKey',
    );

    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final json =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      return CurrentWeatherResponse.fromJson(json);
    } else if (response.statusCode == 401) {
      throw Exception('Неверный API-ключ OpenWeatherMap');
    } else {
      throw Exception('Ошибка загрузки погоды: ${response.statusCode}');
    }
  }

  /// Прогноз на 5 дней (шаг 3 часа)
  Future<ForecastResponse> getForecast(double lat, double lon) async {
    final uri = Uri.parse(
      '$_baseUrl/data/2.5/forecast'
      '?lat=$lat&lon=$lon'
      '&units=$_units&lang=$_lang&appid=$_apiKey',
    );

    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final json =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      return ForecastResponse.fromJson(json);
    } else {
      throw Exception('Ошибка загрузки прогноза: ${response.statusCode}');
    }
  }

  /// Поиск города по названию (прямой геокодинг)
  /// Возвращает список найденных городов
  Future<List<GeoCity>> searchCity(String cityName) async {
    final uri = Uri.parse(
      '$_baseUrl/geo/1.0/direct'
      '?q=$cityName&limit=5&appid=$_apiKey',
    );

    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
      return json
          .map((item) => GeoCity.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Обратный геокодинг: координаты → название города
  Future<String?> getCityNameByCoords(double lat, double lon) async {
    final uri = Uri.parse(
      '$_baseUrl/geo/1.0/reverse'
      '?lat=$lat&lon=$lon&limit=1&lang=$_lang&appid=$_apiKey',
    );

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        if (json.isNotEmpty) {
          return json[0]['local_names']?['ru'] ?? json[0]['name'] as String?;
        }
      }
    } catch (e) {
      print('Ошибка обратного геокодинга: $e');
    }
    return null;
  }
}
