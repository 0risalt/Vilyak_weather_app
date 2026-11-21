import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/weather_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await initializeDateFormatting('ru', null);
  } catch (e) {
    debugPrint('Ошибка инициализации локали: $e');
  }

  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Погода',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF14161C),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF9FB6DC),
          surface: Color(0xFF1F2230),
        ),
        useMaterial3: true,
      ),
      home: const WeatherScreen(),
    );
  }
}