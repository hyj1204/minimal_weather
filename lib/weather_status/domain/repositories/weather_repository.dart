// ignore_for_file: always_use_package_imports

import '../entities/weather_list_entity.dart';

abstract class IWeatherRepository {
  Future<WeatherList> getWeatherList(String city);
}
