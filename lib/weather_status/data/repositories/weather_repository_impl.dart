// ignore_for_file: always_use_package_imports

import 'package:minimal_weather/weather_status/data/datasource/weather_datasource.dart';
import 'package:minimal_weather/weather_status/domain/entities/location_entity.dart';
import 'package:minimal_weather/weather_status/domain/repositories/weather_repository.dart';

import '../../domain/entities/weather_list_entity.dart';

class WeatherRepository implements IWeatherRepository {
  WeatherRepository(this._datasource);

  final IWeatherDataSource _datasource;

  @override
  Future<Location> getLocation(String _city) async {
    try {
      return await _datasource.getLocation(_city);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<WeatherList> getWeatherList(Location _location) async {
    try {
      return await _datasource.getWeatherList(_location);
    } catch (error) {
      rethrow;
    }
  }
}
