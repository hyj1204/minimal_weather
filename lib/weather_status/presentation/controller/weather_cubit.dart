// ignore_for_file: always_use_package_imports

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/temperature_entity.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/usecases/weather_usecase.dart';

part 'weather_cubit.g.dart';
part 'weather_state.dart';

class WeatherController extends HydratedCubit<WeatherState> {
  WeatherController(this._weatherUsecase) : super(const WeatherState());

  final IWeatherUsecase _weatherUsecase;

  Future<void> fetchWeather(String? city) async {
    if (city == null || city.isEmpty) return;

    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      final _listOfWeather = await _weatherUsecase.getWeatherList(city);

      final units = state.temperatureUnits;
      final weatherList = <Weather>[];
      units.isFahrenheit == true
          ? _listOfWeather.weathers.map(
              (Weather e) {
                weatherList.add(
                  e.copyWith(
                    temperature: Temperature(
                      value: e.temperature.value.toFahrenheit(),
                    ),
                  ),
                );
              },
            )
          : _listOfWeather.weathers.map((e) {
              weatherList.add(
                e.copyWith(
                  temperature: Temperature(value: e.temperature.value),
                ),
              );
            });

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
      final _listOfWeather = await _weatherUsecase
          .getWeatherList(state.weatherList.first.location);

      final units = state.temperatureUnits;
      final weatherList = <Weather>[];
      units.isFahrenheit == true
          ? _listOfWeather.weathers.map(
              (Weather e) {
                weatherList.add(
                  e.copyWith(
                    temperature: Temperature(
                      value: e.temperature.value.toFahrenheit(),
                    ),
                  ),
                );
              },
            )
          : _listOfWeather.weathers.map((e) {
              weatherList.add(
                e.copyWith(
                  temperature: Temperature(value: e.temperature.value),
                ),
              );
            });

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
