// ignore_for_file: always_use_package_imports

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'temperature_entity.dart';

@JsonSerializable()
class Weather extends Equatable {
  const Weather({
    required this.condition,
    required this.lastUpdated,
    required this.location,
    required this.temperature,
    required this.date,
  });

  final WeatherCondition condition;
  final DateTime lastUpdated;
  final String location;
  final Temperature temperature;
  final DateTime date;

  @override
  List<Object> get props =>
      [condition, lastUpdated, location, temperature, date];

  Weather copyWith({
    WeatherCondition? condition,
    DateTime? lastUpdated,
    String? location,
    Temperature? temperature,
    DateTime? date,
  }) {
    return Weather(
      condition: condition ?? this.condition,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      location: location ?? this.location,
      temperature: temperature ?? this.temperature,
      date: date ?? this.date,
    );
  }
}

enum WeatherCondition {
  clear,
  rainy,
  cloudy,
  snowy,
  thundery,
  unknown,
}
