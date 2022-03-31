// ignore_for_file: always_use_package_imports

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/failures.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/entities/weather_list_entity.dart';
import '../models/location_model.dart';
import '../models/weather_list_model.dart';

abstract class IWeatherDataSource {
  Future<Location> getLocation(String city);

  Future<WeatherList> getWeatherList(Location location);
}

class WeatherDataSource implements IWeatherDataSource {
  final _httpClient = http.Client();
  static const _baseUrl = 'www.metaweather.com';

  @override
  Future<Location> getLocation(String city) async {
    try {
      final locationRequest = Uri.https(
        _baseUrl,
        '/api/location/search',
        <String, String>{'query': city},
      );
      final locationResponse = await _httpClient.get(locationRequest);

      if (locationResponse.statusCode != 200) {
        throw Failure.locationIdRequestFailure();
      }

      final locationJson = jsonDecode(
        locationResponse.body,
      ) as List;

      if (locationJson.isEmpty) {
        throw Failure.locationNotFoundFailure();
      }

      final _location =
          LocationModel.fromJson(locationJson.first as Map<String, dynamic>);

      return _location;
    } catch (error) {
      throw Failure.unexpectedError();
    }
  }

  @override
  Future<WeatherList> getWeatherList(Location location) async {
    try {
      final weatherRequest =
          Uri.https(_baseUrl, '/api/location/${location.woeid}');
      final weatherResponse = await _httpClient.get(weatherRequest);

      if (weatherResponse.statusCode != 200) {
        throw Failure.weatherRequestFailure();
      }

      final bodyJson = jsonDecode(weatherResponse.body) as Map<String, dynamic>;

      if (bodyJson.isEmpty) {
        throw Failure.weatherNotFoundFailure();
      }

      final _weatherList = WeatherListModel.fromJson(bodyJson, location.title);

      return _weatherList;
    } catch (error) {
      throw Failure.unexpectedError();
    }
  }
}
