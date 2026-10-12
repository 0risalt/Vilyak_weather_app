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
    return MediaQuery(
      // Увеличиваем все шрифты на 30% — на Windows текст слишком мелкий
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.3)),
      child: MaterialApp(
        title: 'Погода',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4A90E2),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.transparent,
        ),
        home: const WeatherScreen(),
      ),
    );
  }
}
