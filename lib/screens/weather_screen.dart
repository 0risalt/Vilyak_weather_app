import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/weather_model.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import '../services/weather_api.dart';
import '../utils/weather_theme.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/forecast_list.dart';
import '../widgets/gradient_background.dart';
import '../widgets/hourly_forecast_list.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _api = WeatherApi();
  final _locationService = LocationService();
  final _storage = StorageService();
  final _cityController = TextEditingController();

  CurrentWeatherResponse? _current;
  ForecastResponse? _forecast;
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _recentCities = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    _recentCities = await _storage.loadRecentCities();
    if (mounted) setState(() {});

    final lastCity = await _storage.loadLastCity();
    if (lastCity != null) {
      await _loadByCoords(
        lastCity['lat'] as double,
        lastCity['lon'] as double,
        cityName: lastCity['name'] as String?,
      );
      return;
    }

    await _loadByGps();
  }

  Future<void> _loadByGps() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final pos = await _locationService.getCurrentLocation();
    if (pos == null) {
      await _loadByCoords(55.7558, 37.6173, cityName: 'Москва');
      return;
    }

    final cityName =
        await _api.getCityNameByCoords(pos.latitude, pos.longitude) ??
            'Моё местоположение';

    await _loadByCoords(pos.latitude, pos.longitude, cityName: cityName);
  }

  Future<void> _loadByCoords(
    double lat,
    double lon, {
    String? cityName,
  }) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final current = await _api.getCurrentWeather(lat, lon);
      final forecast = await _api.getForecast(lat, lon);

      if (!mounted) return;
      setState(() {
        _current = current;
        _forecast = forecast;
        _loading = false;
      });

      await _storage.saveLastCity(
        name: cityName ?? current.name,
        lat: lat,
        lon: lon,
      );
      await _storage.addRecentCity(
        name: cityName ?? current.name,
        lat: lat,
        lon: lon,
      );
      _recentCities = await _storage.loadRecentCities();
      if (mounted) setState(() {});
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _searchCity(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final results = await _api.searchCity(query.trim());
      if (results.isEmpty) {
        setState(() {
          _error = 'Город "$query" не найден';
          _loading = false;
        });
        return;
      }

      final city = results.first;
      _cityController.clear();
      FocusScope.of(context).unfocus();
      await _loadByCoords(city.lat, city.lon, cityName: city.displayName);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _refresh() async {
    if (_current == null) {
      await _loadByGps();
      return;
    }
    await _loadByCoords(
      _current!.coord.lat,
      _current!.coord.lon,
      cityName: _current!.name,
    );
  }

  bool get _isNight {
    if (_current == null) return false;
    return WeatherTheme.isNightTime(
      sunrise: _current!.sys.sunrise,
      sunset: _current!.sys.sunset,
      timezoneOffset: _current!.timezone,
    );
  }

  String get _weatherMain {
    if (_current == null) return 'Clear';
    return _current!.weather.first.main;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        weatherMain: _weatherMain,
        isNight: _isNight,
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refresh,
            color: Colors.white,
            backgroundColor: Colors.transparent,
            child: _buildBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),

          if (_recentCities.isNotEmpty) ...[
            _buildRecentCities(),
            const SizedBox(height: 20),
          ],

          if (_loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 80),
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            )
          else if (_error != null)
            _buildError()
          else if (_current != null) ...[
            CurrentWeatherCard(data: _current!),
            const SizedBox(height: 32),
            if (_forecast != null) ...[
              HourlyForecastList(forecast: _forecast!),
              const SizedBox(height: 32),
              ForecastList(forecast: _forecast!),
              const SizedBox(height: 24),
            ],
            _buildShareButton(),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ПОГОДА',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 11,
            letterSpacing: 3,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Прогноз',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w300,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _cityController,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Найти город',
                  hintStyle:
                      TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
                onSubmitted: _searchCity,
              ),
            ),
            InkWell(
              onTap: _loadByGps,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.my_location,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        Divider(
          color: Colors.white.withValues(alpha: 0.2),
          height: 1,
        ),
      ],
    );
  }

  Widget _buildRecentCities() {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _recentCities.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final city = _recentCities[index];
          return InkWell(
            onTap: () => _loadByCoords(
              city['lat'] as double,
              city['lon'] as double,
              cityName: city['name'] as String,
            ),
            borderRadius: BorderRadius.circular(2),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Center(
                child: Text(
                  city['name'] as String,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Icon(Icons.error_outline,
              color: Colors.white.withValues(alpha: 0.7), size: 48),
          const SizedBox(height: 16),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: _loadByGps,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            child: const Text('ПОПРОБОВАТЬ СНОВА'),
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton() {
    if (_current == null) return const SizedBox();

    return OutlinedButton(
      onPressed: () => _shareWeather(_current!),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.ios_share, size: 16),
          SizedBox(width: 10),
          Text(
            'ПОДЕЛИТЬСЯ',
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 2,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _shareWeather(CurrentWeatherResponse data) async {
    final text = 'Погода в ${data.name}: '
        '${data.main.temp.round()}°, '
        '${data.weather.first.description}. '
        'Ощущается как ${data.main.feelsLike.round()}°, '
        'влажность ${data.main.humidity}%, '
        'ветер ${data.wind.speed.toStringAsFixed(1)} м/с ${data.wind.direction}.';

    try {
      await Share.share(text);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось поделиться: $e')),
      );
    }
  }
}