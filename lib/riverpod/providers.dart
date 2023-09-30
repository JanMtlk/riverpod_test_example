import 'package:test_riverpod/repositories/weather_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_riverpod/riverpod/weather_notifier.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) => FakeWeatherRepository(),
);

final weatherNotifierProvider = StateNotifierProvider(
  (ref) => WeatherNotifier(ref.watch(weatherRepositoryProvider)),
);
