// ignore_for_file: always_use_package_imports

import 'package:minimal_weather/weather_status/domain/entities/temperature_entity.dart';
import 'package:minimal_weather/weather_status/domain/repositories/weather_repository.dart';

import '../entities/weather_entity.dart';
import '../entities/weather_list_entity.dart';

abstract class IWeatherUsecase {
  Future<List<Weather>> getWeatherList(
      String locationId, TemperatureUnits temperatureUnits);
}

class WeatherUsecase implements IWeatherUsecase {
  WeatherUsecase(this._repository);

  final IWeatherRepository _repository;

  @override
  Future<List<Weather>> getWeatherList(
      String city, TemperatureUnits temperatureUnits) async {
    try {
      final _location = await _repository.getLocation(city);
      final _listOfWeather = await _repository.getWeatherList(_location);

      final _weatherList = <Weather>[];
      temperatureUnits.isFahrenheit == true
          ? _listOfWeather.weathers.map(
              (Weather e) {
                _weatherList.add(
                  e.copyWith(
                    temperature: Temperature(
                      value: e.temperature.value.toFahrenheit(),
                    ),
                  ),
                );
              },
            )
          : _listOfWeather.weathers.map((e) {
              _weatherList.add(
                e.copyWith(
                  temperature: Temperature(value: e.temperature.value),
                ),
              );
            });
      return _weatherList;
    } catch (error) {
      rethrow;
    }
  }
}

extension on double {
  double toFahrenheit() => (this * 9 / 5) + 32;
}
