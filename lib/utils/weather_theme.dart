import 'package:flutter/material.dart';

class WeatherTheme {
  /// Приглушённые градиенты — «журнальный» стиль
  static LinearGradient getGradient({
    required String weatherMain,
    required bool isNight,
  }) {
    if (isNight) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF14161C),
          Color(0xFF1F2230),
        ],
      );
    }

    final key = weatherMain.toLowerCase();
    if (key == 'clear') {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF3A5BA0), Color(0xFF6E8CC7)],
      );
    }
    if (key == 'clouds') {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4A5460), Color(0xFF7B8593)],
      );
    }
    if (key == 'rain' || key == 'drizzle' || key == 'thunderstorm') {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF2C3E50), Color(0xFF4A6B8A)],
      );
    }
    if (key == 'snow') {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF7A8FA6), Color(0xFFB4C4D4)],
      );
    }
    if (key == 'mist' || key == 'fog' || key == 'haze') {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF6B6F76), Color(0xFF9AA0A6)],
      );
    }

    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF3A5BA0), Color(0xFF6E8CC7)],
    );
  }

  /// Акцентный цвет для иконок и подчёркиваний
  static const Color accent = Color(0xFF9FB6DC);

  static bool isNightTime({
    required int sunrise,
    required int sunset,
    required int timezoneOffset,
  }) {
    final now = DateTime.now().toUtc().add(Duration(seconds: timezoneOffset));
    final sunriseTime =
        DateTime.fromMillisecondsSinceEpoch(sunrise * 1000, isUtc: true)
            .add(Duration(seconds: timezoneOffset));
    final sunsetTime =
        DateTime.fromMillisecondsSinceEpoch(sunset * 1000, isUtc: true)
            .add(Duration(seconds: timezoneOffset));

    return now.isBefore(sunriseTime) || now.isAfter(sunsetTime);
  }
}