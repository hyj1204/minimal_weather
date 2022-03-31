// ignore_for_file: always_use_package_imports

import 'package:minimal_weather/weather_status/domain/entities/temperature_entity.dart';

import '../../domain/entities/weather_entity.dart';

class WeatherModel extends Weather {
  const WeatherModel({
    required WeatherCondition condition,
    required DateTime lastUpdated,
    required String location,
    required Temperature temperature,
    required DateTime date,
  }) : super(
          condition: condition,
          lastUpdated: lastUpdated,
          location: location,
          temperature: temperature,
          date: date,
        );

  factory WeatherModel.fromJson(
      Map<String, dynamic> json, String locationTitle) {
    return WeatherModel(
      condition: json['condition'] as WeatherCondition,
      lastUpdated: DateTime.now(),
      location: locationTitle,
      temperature: json['temperature'] as Temperature,
      date: json['date'] as DateTime,
    );
  }
}
