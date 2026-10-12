import 'package:flutter/material.dart';

class WeatherTheme {
  /// Градиент для фона в зависимости от погоды и времени
  static LinearGradient getGradient({
    required String weatherMain,
    required bool isNight,
  }) {
    final key = weatherMain.toLowerCase();

    if (isNight) {
      // Ночные градиенты (тёмно-синие/фиолетовые)
      if (key == 'clear') {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
        );
      }
      if (key == 'clouds') {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E293B), Color(0xFF334155)],
        );
      }
      if (key == 'rain' || key == 'drizzle') {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0F172A), Color(0xFF1E3A5F)],
        );
      }
      if (key == 'snow') {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E293B), Color(0xFF475569)],
        );
      }
      if (key == 'thunderstorm') {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0F172A), Color(0xFF312E81)],
        );
      }
      // По умолчанию — ночное
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
      );
    }

    // Дневные градиенты (яркие, светлые)
    if (key == 'clear') {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF4A90E2), Color(0xFF87CEEB)],
      );
    }
    if (key == 'clouds') {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF6B8BB5), Color(0xFFA8B8C8)],
      );
    }
    if (key == 'rain' || key == 'drizzle') {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF4A6B8A), Color(0xFF6B8BB5)],
      );
    }
    if (key == 'snow') {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF9BB5D0), Color(0xFFD0DDE8)],
      );
    }
    if (key == 'thunderstorm') {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF3A3A5C), Color(0xFF6B5B8A)],
      );
    }
    if (key == 'mist' || key == 'fog' || key == 'haze') {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF9E9E9E), Color(0xFFCCCCCC)],
      );
    }

    // Дневной по умолчанию
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF4A90E2), Color(0xFF87CEEB)],
    );
  }

  /// Основной цвет текста в зависимости от времени суток
  static Color getTextColor(bool isNight) =>
      isNight ? Colors.white : Colors.white;

  /// Определяем, ночь ли сейчас, по времени восхода/заката
  static bool isNightTime({
    required int sunrise,
    required int sunset,
    required int timezoneOffset,
  }) {
    final now = DateTime.now().toUtc().add(Duration(seconds: timezoneOffset));
    final sunriseTime = DateTime.fromMillisecondsSinceEpoch(
      sunrise * 1000,
      isUtc: true,
    ).add(Duration(seconds: timezoneOffset));
    final sunsetTime = DateTime.fromMillisecondsSinceEpoch(
      sunset * 1000,
      isUtc: true,
    ).add(Duration(seconds: timezoneOffset));

    return now.isBefore(sunriseTime) || now.isAfter(sunsetTime);
  }
}
