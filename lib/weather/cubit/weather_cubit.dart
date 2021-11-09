import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:minimal_weather/weather/models/weather.dart';
import 'package:weather_repository/weather_repository.dart'
    show WeatherRepository;

part 'weather_cubit.g.dart';
part 'weather_state.dart';

class WeatherCubit extends HydratedCubit<WeatherState> {
  WeatherCubit(this._weatherRepository) : super(const WeatherState());

  final WeatherRepository _weatherRepository;

  Future<void> fetchWeather(String? city) async {
    if (city == null || city.isEmpty) return;

    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      final weatherListFromRepository =
          await _weatherRepository.getWeatherList(city);
      var weatherList = weatherListFromRepository
          .map((e) => Weather.fromRepository(e))
          .toList();

      final units = state.temperatureUnits;
      if (units.isFahrenheit == true) {
        weatherList = weatherList
            .map((e) => e.copyWith(
                temperature:
                    Temperature(value: e.temperature.value.toFahrenheit())))
            .toList();
      } else {
        weatherList = weatherList
            .map((e) => e.copyWith(
                temperature: Temperature(value: e.temperature.value)))
            .toList();
      }

      emit(
        state.copyWith(
          status: WeatherStatus.success,
          temperatureUnits: units,
          weatherList: weatherList,
        ),
      );
    } on Exception {
      emit(state.copyWith(status: WeatherStatus.failure));
    }
  }

  Future<void> refreshWeather() async {
    if (!state.status.isSuccess) return;
    if (state.weatherList.isEmpty) return;
    try {
      final weatherListFromRepository = await _weatherRepository
          .getWeatherList(state.weatherList.first.location);
      var weatherList = weatherListFromRepository
          .map((e) => Weather.fromRepository(e))
          .toList();

      final units = state.temperatureUnits;
      if (units.isFahrenheit == true) {
        weatherList = weatherList
            .map((e) => e.copyWith(
                temperature:
                    Temperature(value: e.temperature.value.toFahrenheit())))
            .toList();
      } else {
        weatherList = weatherList
            .map((e) => e.copyWith(
                temperature: Temperature(value: e.temperature.value)))
            .toList();
      }

      emit(
        state.copyWith(
          status: WeatherStatus.success,
          temperatureUnits: units,
          weatherList: weatherList,
        ),
      );
    } on Exception {
      emit(state);
    }
  }

  void toggleUnits() {
    final units = state.temperatureUnits.isFahrenheit
        ? TemperatureUnits.celsius
        : TemperatureUnits.fahrenheit;

    if (!state.status.isSuccess) {
      emit(state.copyWith(temperatureUnits: units));
      return;
    }

    var weatherList = state.weatherList;
    if (weatherList.isNotEmpty) {
      if (units.isFahrenheit == true) {
        weatherList = weatherList
            .map((e) => e.copyWith(
                temperature:
                    Temperature(value: e.temperature.value.toFahrenheit())))
            .toList();
      } else {
        weatherList = weatherList
            .map((e) => e.copyWith(
                temperature:
                    Temperature(value: e.temperature.value.toCelsius())))
            .toList();
      }
      emit(
        state.copyWith(
          temperatureUnits: units,
          weatherList: weatherList,
        ),
      );
    }
  }

  @override
  WeatherState fromJson(Map<String, dynamic> json) =>
      WeatherState.fromJson(json);

  @override
  Map<String, dynamic> toJson(WeatherState state) => state.toJson();
}

extension on double {
  double toFahrenheit() => (this * 9 / 5) + 32;
  double toCelsius() => (this - 32) * 5 / 9;
}
