import 'package:json_annotation/json_annotation.dart';

part 'weather_model.g.dart';

// ============================
// ТЕКУЩАЯ ПОГОДА
// ============================

@JsonSerializable()
class CurrentWeatherResponse {
  final Coord coord;
  final List<WeatherInfo> weather;
  final MainInfo main;
  final WindInfo wind;
  final SysInfo sys;
  final int timezone;
  final String name;

  CurrentWeatherResponse({
    required this.coord,
    required this.weather,
    required this.main,
    required this.wind,
    required this.sys,
    required this.timezone,
    required this.name,
  });

  factory CurrentWeatherResponse.fromJson(Map<String, dynamic> json) =>
      _$CurrentWeatherResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentWeatherResponseToJson(this);
}

@JsonSerializable()
class Coord {
  final double lat;
  final double lon;
  Coord({required this.lat, required this.lon});
  factory Coord.fromJson(Map<String, dynamic> json) => _$CoordFromJson(json);
  Map<String, dynamic> toJson() => _$CoordToJson(this);
}

@JsonSerializable()
class WeatherInfo {
  final int id;
  final String main;
  final String description;
  final String icon;
  WeatherInfo({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });
  factory WeatherInfo.fromJson(Map<String, dynamic> json) =>
      _$WeatherInfoFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherInfoToJson(this);
}

@JsonSerializable()
class MainInfo {
  final double temp;

  @JsonKey(name: 'feels_like')
  final double feelsLike;

  @JsonKey(name: 'temp_min')
  final double tempMin;

  @JsonKey(name: 'temp_max')
  final double tempMax;

  final int pressure;
  final int humidity;

  MainInfo({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
  });

  factory MainInfo.fromJson(Map<String, dynamic> json) =>
      _$MainInfoFromJson(json);

  Map<String, dynamic> toJson() => _$MainInfoToJson(this);
}

@JsonSerializable()
class WindInfo {
  final double speed;
  final int deg;
  final double? gust;

  WindInfo({required this.speed, required this.deg, this.gust});

  factory WindInfo.fromJson(Map<String, dynamic> json) =>
      _$WindInfoFromJson(json);

  Map<String, dynamic> toJson() => _$WindInfoToJson(this);

  /// Направление ветра текстом
  String get direction {
    const directions = ['С', 'СВ', 'В', 'ЮВ', 'Ю', 'ЮЗ', 'З', 'СЗ'];
    final index = ((deg + 22.5) / 45).floor() % 8;
    return directions[index];
  }
}

@JsonSerializable()
class SysInfo {
  final String? country;
  final int sunrise;
  final int sunset;

  SysInfo({this.country, required this.sunrise, required this.sunset});

  factory SysInfo.fromJson(Map<String, dynamic> json) =>
      _$SysInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SysInfoToJson(this);
}

// ============================
// ПРОГНОЗ НА 5 ДНЕЙ
// ============================

@JsonSerializable()
class ForecastResponse {
  final String cod;
  final int cnt;
  final List<ForecastItem> list;
  final CityInfo city;

  ForecastResponse({
    required this.cod,
    required this.cnt,
    required this.list,
    required this.city,
  });

  factory ForecastResponse.fromJson(Map<String, dynamic> json) =>
      _$ForecastResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ForecastResponseToJson(this);

  /// Группировка прогноза по дням (упрощённая: одна запись на день)
  /// Берём запись ближе к 12:00 и агрегируем min/max по дню.
  List<DailyForecast> get dailyForecasts {
    final Map<String, List<ForecastItem>> byDay = {};

    for (final item in list) {
      final date = DateTime.fromMillisecondsSinceEpoch(
        item.dt * 1000,
        isUtc: true,
      ).add(Duration(seconds: city.timezone));
      final key = '${date.year}-${date.month}-${date.day}';
      byDay.putIfAbsent(key, () => []).add(item);
    }

    final result = <DailyForecast>[];
    for (final entry in byDay.entries) {
      final items = entry.value;
      if (items.isEmpty) continue;

      // Находим запись ближе к 12:00
      ForecastItem representative = items.first;
      int minDiff = 24;
      for (final item in items) {
        final date = DateTime.fromMillisecondsSinceEpoch(
          item.dt * 1000,
          isUtc: true,
        ).add(Duration(seconds: city.timezone));
        final diff = (date.hour - 12).abs();
        if (diff < minDiff) {
          minDiff = diff;
          representative = item;
        }
      }

      final maxTemp = items
          .map((e) => e.main.tempMax)
          .reduce((a, b) => a > b ? a : b);
      final minTemp = items
          .map((e) => e.main.tempMin)
          .reduce((a, b) => a < b ? a : b);

      result.add(
        DailyForecast(
          date: DateTime.fromMillisecondsSinceEpoch(
            representative.dt * 1000,
            isUtc: true,
          ).add(Duration(seconds: city.timezone)),
          tempMax: maxTemp,
          tempMin: minTemp,
          weather: representative.weather.first,
          humidity: representative.main.humidity,
          windSpeed: representative.wind.speed,
        ),
      );
    }

    result.sort((a, b) => a.date.compareTo(b.date));
    return result;
  }

  /// Почасовой прогноз на ближайшие 24 часа (8 записей по 3 часа)
  List<ForecastItem> get hourlyForecast => list.take(8).toList();
}

@JsonSerializable()
class ForecastItem {
  final int dt;
  final MainInfo main;
  final List<WeatherInfo> weather;
  final WindInfo wind;

  @JsonKey(name: 'dt_txt')
  final String dtTxt;

  ForecastItem({
    required this.dt,
    required this.main,
    required this.weather,
    required this.wind,
    required this.dtTxt,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) =>
      _$ForecastItemFromJson(json);

  Map<String, dynamic> toJson() => _$ForecastItemToJson(this);

  DateTime get dateTime =>
      DateTime.fromMillisecondsSinceEpoch(dt * 1000, isUtc: true);
}

@JsonSerializable()
class CityInfo {
  final String name;
  final Coord coord;
  final String country;
  final int timezone;
  final int sunrise;
  final int sunset;

  CityInfo({
    required this.name,
    required this.coord,
    required this.country,
    required this.timezone,
    required this.sunrise,
    required this.sunset,
  });

  factory CityInfo.fromJson(Map<String, dynamic> json) =>
      _$CityInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CityInfoToJson(this);
}

/// Модель для дневной агрегации (не парсится из JSON, строится вручную)
class DailyForecast {
  final DateTime date;
  final double tempMax;
  final double tempMin;
  final WeatherInfo weather;
  final int humidity;
  final double windSpeed;

  DailyForecast({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.weather,
    required this.humidity,
    required this.windSpeed,
  });
}

// ============================
// ГЕОКОДИНГ (OpenWeatherMap /geo/1.0)
// ============================

@JsonSerializable()
class GeoCity {
  final String name;
  final double lat;
  final double lon;
  final String country;
  final String? state;

  GeoCity({
    required this.name,
    required this.lat,
    required this.lon,
    required this.country,
    this.state,
  });

  factory GeoCity.fromJson(Map<String, dynamic> json) =>
      _$GeoCityFromJson(json);

  Map<String, dynamic> toJson() => _$GeoCityToJson(this);

  /// Полное название для отображения
  String get displayName {
    if (state != null && state!.isNotEmpty) {
      return '$name, $state, $country';
    }
    return '$name, $country';
  }
}
