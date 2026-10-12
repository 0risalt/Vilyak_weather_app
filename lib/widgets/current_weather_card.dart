import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/weather_model.dart';
import '../utils/weather_icons.dart';

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

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Город
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 24),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      data.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Температура + иконка
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    WeatherIcons.fromCode(weather.icon),
                    style: const TextStyle(fontSize: 80),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${main.temp.round()}°',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 84,
                            fontWeight: FontWeight.w200,
                            height: 1,
                          ),
                        ),
                        Text(
                          weather.description,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Ощущается как ${main.feelsLike.round()}°',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Детали
              Row(
                children: [
                  Expanded(
                    child: _DetailItem(
                      icon: Icons.water_drop,
                      label: 'Влажность',
                      value: '${main.humidity}%',
                    ),
                  ),
                  Expanded(
                    child: _DetailItem(
                      icon: Icons.speed,
                      label: 'Давление',
                      value: '${(main.pressure * 0.750064).round()} мм',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _DetailItem(
                      icon: Icons.air,
                      label: 'Ветер',
                      value:
                          '${wind.speed.toStringAsFixed(1)} м/с ${wind.direction}',
                    ),
                  ),
                  Expanded(
                    child: _DetailItem(
                      icon: Icons.wb_sunny,
                      label: 'Восход',
                      value: DateFormat('HH:mm').format(sunriseTime),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _DetailItem(
                      icon: Icons.nightlight_round,
                      label: 'Закат',
                      value: DateFormat('HH:mm').format(sunsetTime),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 22),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 13,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
