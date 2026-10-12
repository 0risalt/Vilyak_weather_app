class WeatherIcons {
  /// Преобразует код иконки OpenWeatherMap (например, "04d") в эмодзи
  static String fromCode(String iconCode) {
    // Отрезаем последний символ (d/n — день/ночь)
    final code = iconCode.substring(0, 2);

    switch (code) {
      case '01': // clear sky
        return iconCode.endsWith('n') ? '🌙' : '☀️';
      case '02': // few clouds
        return iconCode.endsWith('n') ? '☁️' : '🌤️';
      case '03': // scattered clouds
        return '⛅';
      case '04': // broken clouds
        return '☁️';
      case '09': // shower rain
        return '🌧️';
      case '10': // rain
        return iconCode.endsWith('n') ? '🌧️' : '🌦️';
      case '11': // thunderstorm
        return '⛈️';
      case '13': // snow
        return '❄️';
      case '50': // mist
        return '🌫️';
      default:
        return '🌡️';
    }
  }

  /// Описание погоды на русском по коду
  static String descriptionFromCode(String iconCode) {
    final code = iconCode.substring(0, 2);
    switch (code) {
      case '01':
        return 'Ясно';
      case '02':
        return 'Малооблачно';
      case '03':
        return 'Облачно';
      case '04':
        return 'Пасмурно';
      case '09':
        return 'Ливень';
      case '10':
        return 'Дождь';
      case '11':
        return 'Гроза';
      case '13':
        return 'Снег';
      case '50':
        return 'Туман';
      default:
        return '—';
    }
  }
}
