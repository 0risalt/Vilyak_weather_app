import 'package:flutter/material.dart';

class WeatherIcons {
  /// Возвращает Material-иконку по коду OpenWeatherMap
  static IconData iconFromCode(String iconCode) {
    final code = iconCode.substring(0, 2);
    final isNight = iconCode.endsWith('n');

    switch (code) {
      case '01':
        return isNight ? Icons.nightlight_round : Icons.wb_sunny_outlined;
      case '02':
        return isNight
            ? Icons.nights_stay_outlined
            : Icons.wb_cloudy_outlined;
      case '03':
        return Icons.cloud_outlined;
      case '04':
        return Icons.cloud;
      case '09':
        return Icons.grain;
      case '10':
        return Icons.umbrella;
      case '11':
        return Icons.thunderstorm_outlined;
      case '13':
        return Icons.ac_unit;
      case '50':
        return Icons.blur_on;
      default:
        return Icons.thermostat;
    }
  }
}