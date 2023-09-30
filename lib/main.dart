import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_riverpod/models/weather.dart';
import 'package:test_riverpod/riverpod/providers.dart';
import 'package:test_riverpod/riverpod/weather_states.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const WeatherSearchPage(),
      ),
    );
  }
}

class WeatherSearchPage extends StatelessWidget {
  const WeatherSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather Search"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: Consumer(
          builder: (context, ref, child) {
            final state = ref.watch(weatherNotifierProvider);

            if (state is WeatherInitial) {
              return buildInitialInput();
            } else if (state is WeatherLoading) {
              return buildLoading();
            } else if (state is WeatherLoaded) {
              return buildColumnWithData(state.weather);
            } else {
              // (state is WeatherError)

              return buildInitialInput();
            }
          },
        ),
      ),
    );
  }

  Widget buildInitialInput() {
    return Center(
      child: CityInputField(),
    );
  }

  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Column buildColumnWithData(Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          weather.cityName,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          "${weather.temperature.toStringAsFixed(1)} °C",
          style: const TextStyle(fontSize: 80),
        ),
        CityInputField(),
      ],
    );
  }

  Widget CityInputField() {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(weatherNotifierProvider);
        void submitCityName(BuildContext context, String cityName) {
          ref.read(weatherNotifierProvider.notifier).getWeather(cityName);
        }

        return TextField(
          onSubmitted: (value) => submitCityName(context, value),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: state is WeatherError ? state.message : "Enter a city",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: const Icon(Icons.search),
          ),
        );
      },
    );
  }
}
