import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/weather_model.dart';
import '../utils/weather_icons.dart';

class ForecastList extends StatelessWidget {
  final ForecastResponse forecast;

  const ForecastList({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    final daily = forecast.dailyForecasts;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.white, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Прогноз на 5 дней',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...daily.asMap().entries.map((entry) {
                final index = entry.key;
                final day = entry.value;
                return _ForecastRow(
                  day: day,
                  isLast: index == daily.length - 1,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _ForecastRow extends StatelessWidget {
  final DailyForecast day;
  final bool isLast;

  const _ForecastRow({required this.day, required this.isLast});

  String _formatWeekday(DateTime date) {
    try {
      return DateFormat('EEEE', 'ru').format(date);
    } catch (_) {
      return DateFormat('EEEE', 'en').format(date);
    }
  }

  String _formatDate(DateTime date) {
    try {
      return DateFormat('d MMM', 'ru').format(date);
    } catch (_) {
      return DateFormat('d MMM', 'en').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // День недели + дата
              SizedBox(
                width: 140,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatWeekday(day.date),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(day.date),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 13,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),

              // Иконка
              Text(
                WeatherIcons.fromCode(day.weather.icon),
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 14),

              // Описание
              Expanded(
                child: Text(
                  day.weather.description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Мин/макс
              Text(
                '${day.tempMin.round()}°',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${day.tempMax.round()}°',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
      ],
    );
  }
}
