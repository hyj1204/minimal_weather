import 'dart:async';

import 'package:meta_weather_api/meta_weather_api.dart' hide Weather;
import 'package:weather_repository/weather_repository.dart';

class WeatherFailure implements Exception {}

class WeatherRepository {
  WeatherRepository({MetaWeatherApiClient? weatherApiClient})
      : _weatherApiClient = weatherApiClient ?? MetaWeatherApiClient();

  final MetaWeatherApiClient _weatherApiClient;

  Future<List<Weather>> getWeatherList(String city) async {
    final location = await _weatherApiClient.locationSearch(city);
    final woeid = location.woeid;
    final apiWeatherList = await _weatherApiClient.getWeatherList(woeid);
    final weathreList = apiWeatherList
        .map((e) => Weather(
            location: location.title,
            temperature: e.theTemp,
            condition: e.weatherStateAbbr.toCondition,
            date: e.applicableDate))
        .toList();
    return weathreList;

    // return Weather(
    //   temperature: weather.theTemp,
    //   location: location.title,
    //   condition: weather.weatherStateAbbr.toCondition,
    // );
  }
}

//在repository里面用到的condition类型
extension on WeatherState {
  WeatherCondition get toCondition {
    switch (this) {
      case WeatherState.clear:
        return WeatherCondition.clear;
      case WeatherState.snow:
        return WeatherCondition.snowy;
      case WeatherState.sleet:
      case WeatherState.hail:
        return WeatherCondition.snowy;
      case WeatherState.thunderstorm:
        return WeatherCondition.thundery;
      case WeatherState.heavyRain:
        return WeatherCondition.rainy;
      case WeatherState.lightRain:
        return WeatherCondition.rainy;
      case WeatherState.showers:
        return WeatherCondition.rainy;
      case WeatherState.heavyCloud:
        return WeatherCondition.cloudy;
      case WeatherState.lightCloud:
        return WeatherCondition.cloudy;
      default:
        return WeatherCondition.unknown;
    }
  }
}
