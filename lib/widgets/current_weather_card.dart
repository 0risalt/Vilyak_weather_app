import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';
import '../utils/weather_icons.dart';
import '../utils/weather_theme.dart';

class CurrentWeatherCard extends StatelessWidget {
  final CurrentWeatherResponse data;

  const CurrentWeatherCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final weather = data.weather.first;
    final main = data.main;
    final wind = data.wind;

    final sunriseTime = DateTime.fromMillisecondsSinceEpoch(
      data.sys.sunrise * 1000,
      isUtc: true,
    ).add(Duration(seconds: data.timezone));
    final sunsetTime = DateTime.fromMillisecondsSinceEpoch(
      data.sys.sunset * 1000,
      isUtc: true,
    ).add(Duration(seconds: data.timezone));

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Город и страна
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Colors.white.withValues(alpha: 0.7),
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                data.name.toUpperCase(),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Температура крупно, иконка справа
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${main.temp.round()}°',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 96,
                        fontWeight: FontWeight.w200,
                        height: 0.9,
                        letterSpacing: -3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      weather.description.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: 12,
                        letterSpacing: 1.8,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ощущается как ${main.feelsLike.round()}°',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Icon(
                  WeatherIcons.iconFromCode(weather.icon),
                  size: 72,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Детальная строка внизу
          Row(
            children: [
              Expanded(
                child: _Stat(
                  icon: Icons.water_drop_outlined,
                  value: '${main.humidity}%',
                  label: 'ВЛАЖНОСТЬ',
                ),
              ),
              Expanded(
                child: _Stat(
                  icon: Icons.compress,
                  value: '${(main.pressure * 0.750064).round()}',
                  label: 'ММ РТ.СТ.',
                ),
              ),
              Expanded(
                child: _Stat(
                  icon: Icons.air,
                  value: '${wind.speed.toStringAsFixed(0)} ${wind.direction}',
                  label: 'ВЕТЕР',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Восход / закат
          Row(
            children: [
              Expanded(
                child: _Stat(
                  icon: Icons.wb_twilight,
                  value: DateFormat('HH:mm').format(sunriseTime),
                  label: 'ВОСХОД',
                ),
              ),
              Expanded(
                child: _Stat(
                  icon: Icons.nightlight_outlined,
                  value: DateFormat('HH:mm').format(sunsetTime),
                  label: 'ЗАКАТ',
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _Stat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.6)),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.45),
            fontSize: 10,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}