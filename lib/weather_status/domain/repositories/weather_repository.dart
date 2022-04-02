// ignore_for_file: always_use_package_imports

import '../entities/location_entity.dart';
import '../entities/weather_list_entity.dart';

abstract class IWeatherRepository {
  Future<Location> getLocation(String city);

  Future<WeatherList> getWeatherList(Location location);
}
