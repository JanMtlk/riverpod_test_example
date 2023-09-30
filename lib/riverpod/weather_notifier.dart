import 'package:test_riverpod/repositories/weather_repository.dart';
import 'package:test_riverpod/riverpod/weather_states.dart';
import 'package:state_notifier/state_notifier.dart';

class WeatherNotifier extends StateNotifier<WeatherState> {
  final WeatherRepository _weatherRepository;

  WeatherNotifier(this._weatherRepository) : super(const WeatherInitial());

  Future<void> getWeather(String cityName) async {
    try {
      state = const WeatherLoading();

      final weather = await _weatherRepository.fetchWeather(cityName);

      state = WeatherLoaded(weather);
    } on NetworkException {
      state =
          const WeatherError("Couldn't fetch weather. Is the device online?");
    }
  }
}
