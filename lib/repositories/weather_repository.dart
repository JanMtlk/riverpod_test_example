import 'dart:math';

import 'package:test_riverpod/models/weather.dart';

class WeatherRepository {
  Future<Weather> fetchWeather(String cityName) {
    return Future(() => Weather(cityName: "Aš", temperature: 20.0));
  }
}

class FakeWeatherRepository implements WeatherRepository {
  double cachedTempCelsius = 0.0;

  @override
  Future<Weather> fetchWeather(String cityName) {
    // Simulate network delay

    return Future.delayed(
      const Duration(seconds: 1),
      () {
        final random = Random();

        // Simulate some network exception

        if (random.nextBool()) {
          throw NetworkException();
        }

        // Since we're inside a fake repository, we need to cache the temperature

        // in order to have the same one returned in for the detailed weather

        cachedTempCelsius = 20 + random.nextInt(15) + random.nextDouble();

        // Return "fetched" weather

        return Weather(
          cityName: cityName,

          // Temperature between 20 and 35.99

          temperature: cachedTempCelsius,
        );
      },
    );
  }
}

class NetworkException implements Exception {}
