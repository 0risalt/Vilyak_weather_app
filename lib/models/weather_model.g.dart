// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentWeatherResponse _$CurrentWeatherResponseFromJson(
  Map<String, dynamic> json,
) => CurrentWeatherResponse(
  coord: Coord.fromJson(json['coord'] as Map<String, dynamic>),
  weather: (json['weather'] as List<dynamic>)
      .map((e) => WeatherInfo.fromJson(e as Map<String, dynamic>))
      .toList(),
  main: MainInfo.fromJson(json['main'] as Map<String, dynamic>),
  wind: WindInfo.fromJson(json['wind'] as Map<String, dynamic>),
  sys: SysInfo.fromJson(json['sys'] as Map<String, dynamic>),
  timezone: (json['timezone'] as num).toInt(),
  name: json['name'] as String,
);

Map<String, dynamic> _$CurrentWeatherResponseToJson(
  CurrentWeatherResponse instance,
) => <String, dynamic>{
  'coord': instance.coord,
  'weather': instance.weather,
  'main': instance.main,
  'wind': instance.wind,
  'sys': instance.sys,
  'timezone': instance.timezone,
  'name': instance.name,
};

Coord _$CoordFromJson(Map<String, dynamic> json) => Coord(
  lat: (json['lat'] as num).toDouble(),
  lon: (json['lon'] as num).toDouble(),
);

Map<String, dynamic> _$CoordToJson(Coord instance) => <String, dynamic>{
  'lat': instance.lat,
  'lon': instance.lon,
};

WeatherInfo _$WeatherInfoFromJson(Map<String, dynamic> json) => WeatherInfo(
  id: (json['id'] as num).toInt(),
  main: json['main'] as String,
  description: json['description'] as String,
  icon: json['icon'] as String,
);

Map<String, dynamic> _$WeatherInfoToJson(WeatherInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'main': instance.main,
      'description': instance.description,
      'icon': instance.icon,
    };

MainInfo _$MainInfoFromJson(Map<String, dynamic> json) => MainInfo(
  temp: (json['temp'] as num).toDouble(),
  feelsLike: (json['feels_like'] as num).toDouble(),
  tempMin: (json['temp_min'] as num).toDouble(),
  tempMax: (json['temp_max'] as num).toDouble(),
  pressure: (json['pressure'] as num).toInt(),
  humidity: (json['humidity'] as num).toInt(),
);

Map<String, dynamic> _$MainInfoToJson(MainInfo instance) => <String, dynamic>{
  'temp': instance.temp,
  'feels_like': instance.feelsLike,
  'temp_min': instance.tempMin,
  'temp_max': instance.tempMax,
  'pressure': instance.pressure,
  'humidity': instance.humidity,
};

WindInfo _$WindInfoFromJson(Map<String, dynamic> json) => WindInfo(
  speed: (json['speed'] as num).toDouble(),
  deg: (json['deg'] as num).toInt(),
  gust: (json['gust'] as num?)?.toDouble(),
);

Map<String, dynamic> _$WindInfoToJson(WindInfo instance) => <String, dynamic>{
  'speed': instance.speed,
  'deg': instance.deg,
  'gust': instance.gust,
};

SysInfo _$SysInfoFromJson(Map<String, dynamic> json) => SysInfo(
  country: json['country'] as String?,
  sunrise: (json['sunrise'] as num).toInt(),
  sunset: (json['sunset'] as num).toInt(),
);

Map<String, dynamic> _$SysInfoToJson(SysInfo instance) => <String, dynamic>{
  'country': instance.country,
  'sunrise': instance.sunrise,
  'sunset': instance.sunset,
};

ForecastResponse _$ForecastResponseFromJson(Map<String, dynamic> json) =>
    ForecastResponse(
      cod: json['cod'] as String,
      cnt: (json['cnt'] as num).toInt(),
      list: (json['list'] as List<dynamic>)
          .map((e) => ForecastItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      city: CityInfo.fromJson(json['city'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ForecastResponseToJson(ForecastResponse instance) =>
    <String, dynamic>{
      'cod': instance.cod,
      'cnt': instance.cnt,
      'list': instance.list,
      'city': instance.city,
    };

ForecastItem _$ForecastItemFromJson(Map<String, dynamic> json) => ForecastItem(
  dt: (json['dt'] as num).toInt(),
  main: MainInfo.fromJson(json['main'] as Map<String, dynamic>),
  weather: (json['weather'] as List<dynamic>)
      .map((e) => WeatherInfo.fromJson(e as Map<String, dynamic>))
      .toList(),
  wind: WindInfo.fromJson(json['wind'] as Map<String, dynamic>),
  dtTxt: json['dt_txt'] as String,
);

Map<String, dynamic> _$ForecastItemToJson(ForecastItem instance) =>
    <String, dynamic>{
      'dt': instance.dt,
      'main': instance.main,
      'weather': instance.weather,
      'wind': instance.wind,
      'dt_txt': instance.dtTxt,
    };

CityInfo _$CityInfoFromJson(Map<String, dynamic> json) => CityInfo(
  name: json['name'] as String,
  coord: Coord.fromJson(json['coord'] as Map<String, dynamic>),
  country: json['country'] as String,
  timezone: (json['timezone'] as num).toInt(),
  sunrise: (json['sunrise'] as num).toInt(),
  sunset: (json['sunset'] as num).toInt(),
);

Map<String, dynamic> _$CityInfoToJson(CityInfo instance) => <String, dynamic>{
  'name': instance.name,
  'coord': instance.coord,
  'country': instance.country,
  'timezone': instance.timezone,
  'sunrise': instance.sunrise,
  'sunset': instance.sunset,
};

GeoCity _$GeoCityFromJson(Map<String, dynamic> json) => GeoCity(
  name: json['name'] as String,
  lat: (json['lat'] as num).toDouble(),
  lon: (json['lon'] as num).toDouble(),
  country: json['country'] as String,
  state: json['state'] as String?,
);

Map<String, dynamic> _$GeoCityToJson(GeoCity instance) => <String, dynamic>{
  'name': instance.name,
  'lat': instance.lat,
  'lon': instance.lon,
  'country': instance.country,
  'state': instance.state,
};
