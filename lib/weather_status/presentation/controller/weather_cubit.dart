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
      final _listOfWeather =
          await _weatherUsecase.getWeatherList(city, state.temperatureUnits);

      emit(
        state.copyWith(
          status: WeatherStatus.success,
          temperatureUnits: state.temperatureUnits,
          weatherList: _listOfWeather,
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
      final _listOfWeather = await _weatherUsecase.getWeatherList(
          state.weatherList.first.location, state.temperatureUnits);

      emit(
        state.copyWith(
          status: WeatherStatus.success,
          temperatureUnits: state.temperatureUnits,
          weatherList: _listOfWeather,
        ),
      );
    } on Exception {
      emit(state);
    }
  }

  @override
  WeatherState fromJson(Map<String, dynamic> json) =>
      WeatherState.fromJson(json);

  @override
  Map<String, dynamic> toJson(WeatherState state) => state.toJson();
}
