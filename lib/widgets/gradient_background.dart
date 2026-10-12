import 'package:flutter/material.dart';

import '../utils/weather_theme.dart';

class GradientBackground extends StatelessWidget {
  final String weatherMain;
  final bool isNight;
  final Widget child;

  const GradientBackground({
    super.key,
    required this.weatherMain,
    required this.isNight,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: WeatherTheme.getGradient(
          weatherMain: weatherMain,
          isNight: isNight,
        ),
      ),
      child: child,
    );
  }
}
