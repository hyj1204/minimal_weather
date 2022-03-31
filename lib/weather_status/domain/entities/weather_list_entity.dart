// ignore_for_file: always_use_package_imports

import 'package:equatable/equatable.dart';

import 'weather_entity.dart';

class WeatherList extends Equatable {
  const WeatherList(this.weatherList);

  final List<Weather> weatherList;

  @override
  List<Object?> get props => [weatherList];
}
