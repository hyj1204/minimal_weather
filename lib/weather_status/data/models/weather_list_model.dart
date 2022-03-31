// ignore_for_file: always_use_package_imports

import 'package:minimal_weather/weather_status/domain/entities/weather_entity.dart';

import '../../domain/entities/weather_list_entity.dart';
import 'weather_model.dart';

class WeatherListModel extends WeatherList {
  const WeatherListModel(List<Weather> weatherList) : super(weatherList);

  factory WeatherListModel.fromJson(
      Map<String, dynamic> json, String locationTitle) {
    final _weatherJsonList =
        json['consolidated_weather'] as List<Map<String, dynamic>>;
    final _weatherList = <Weather>[];

    for (final element in _weatherJsonList) {
      _weatherList.add(
        WeatherModel.fromJson(element, locationTitle),
      );
    }

    return WeatherListModel(_weatherList);
  }
}
