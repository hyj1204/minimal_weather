// ignore_for_file: always_use_package_imports

import 'package:minimal_weather/weather_status/data/datasource/weather_datasource.dart';
import 'package:minimal_weather/weather_status/domain/repositories/weather_repository.dart';

import '../../domain/entities/weather_list_entity.dart';

class WeatherRepository implements IWeatherRepository {
  WeatherRepository(this._datasource);

  final IWeatherDataSource _datasource;

  @override
  Future<WeatherList> getWeatherList(String city) async {
    try {
      final _location = await _datasource.getLocation(city);
      final _weatherList = await _datasource.getWeatherList(_location);
      return _weatherList;
    } catch (error) {
      rethrow;
    }
  }
}
