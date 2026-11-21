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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Text(
                'ПРОГНОЗ НА 5 ДНЕЙ',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55),
                  fontSize: 11,
                  letterSpacing: 1.8,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Divider(
                  color: Colors.white.withValues(alpha: 0.15),
                  height: 1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ...daily.asMap().entries.map((entry) {
          final index = entry.key;
          final day = entry.value;
          return _ForecastRow(
            day: day,
            isLast: index == daily.length - 1,
          );
        }),
      ],
    );
  }
}

class _ForecastRow extends StatelessWidget {
  final DailyForecast day;
  final bool isLast;

  const _ForecastRow({required this.day, required this.isLast});

  String _weekday(DateTime date) {
    try {
      return DateFormat('EEEE', 'ru').format(date);
    } catch (_) {
      return DateFormat('EEEE', 'en').format(date);
    }
  }

  String _date(DateTime date) {
    try {
      return DateFormat('d MMMM', 'ru').format(date);
    } catch (_) {
      return DateFormat('d MMMM', 'en').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 130,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _weekday(day.date),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _date(day.date),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            WeatherIcons.iconFromCode(day.weather.icon),
            size: 26,
            color: Colors.white.withValues(alpha: 0.85),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Text(
              day.weather.description,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Text(
            '${day.tempMin.round()}°',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 14),
          Text(
            '${day.tempMax.round()}°',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}