// ignore_for_file: always_use_package_imports

import 'package:minimal_weather/weather_status/domain/repositories/weather_repository.dart';

import '../entities/weather_list_entity.dart';

abstract class IWeatherUsecase {
  Future<WeatherList> getWeatherList(String locationId);
}

class WeatherUsecase implements IWeatherUsecase {
  WeatherUsecase(this._repository);

  final IWeatherRepository _repository;

  @override
  Future<WeatherList> getWeatherList(String city) async =>
      _repository.getWeatherList(city);
}
