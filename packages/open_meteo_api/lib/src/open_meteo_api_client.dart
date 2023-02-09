import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:open_meteo_api/open_meteo_api.dart';

/// Exception thrown when locationSearch fails.
class LocationRequestFailure implements Exception {}

/// Exception thrown when the provided location is not found.
class LocationNotFoundFailure implements Exception {}

/// Exception thrown when getWeather fails.
class WeatherRequestFailure implements Exception {}

/// Exception thrown when weather for provided location is not found.
class WeatherNotFoundFailure implements Exception {}

/// {@template open_meteo_api_client}
/// Dart API Client which wraps the [Open Meteo API](https://open-meteo.com).
/// {@endtemplate}
class OpenMeteoApiClient {
  /// {@macro open_meteo_api_client}
  OpenMeteoApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrlWeather = 'api.open-meteo.com';
  static const _baseUrlGeocoding = 'geocoding-api.open-meteo.com';

  final http.Client _httpClient;

  /// Finds a [Location] `/v1/search/?name=(query)`.
  Future<Location> locationSearch(String query) async {
    final locationRequest = Uri.https(
      _baseUrlGeocoding,
      '/v1/search',
      {'name': query, 'count': '1'},
    );

    final locationResponse = await _httpClient.get(locationRequest);

    if (locationResponse.statusCode != 200) {
      throw LocationRequestFailure();
    }

    final locationJson = jsonDecode(locationResponse.body) as Map;

    if (!locationJson.containsKey('results')) throw LocationNotFoundFailure();

    final results = locationJson['results'] as List;

    if (results.isEmpty) throw LocationNotFoundFailure();

    return Location.fromJson(results.first as Map<String, dynamic>);
  }

  /// Fetches [Weather] for a given [latitude] and [longitude].
  Future<List<Weather>> getWeatherList({
    required double latitude,
    required double longitude,
  }) async {
    final timeZone = DateTime.now().timeZoneName;
    final startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final endDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().add(const Duration(days: 5)));
    final weatherRequest = Uri.https(_baseUrlWeather, 'v1/forecast', {
      'latitude': '$latitude',
      'longitude': '$longitude',
      'daily': ['weathercode', 'temperature_2m_max'],
      'timezone': timeZone,
      'start_date': startDate,
      'end_date': endDate,
    });

    print(weatherRequest);

    final weatherResponse = await _httpClient.get(weatherRequest);

    if (weatherResponse.statusCode != 200) {
      //TODO(yijing): show error message
      throw WeatherRequestFailure();
    }

    final bodyJson = jsonDecode(weatherResponse.body) as Map<String, dynamic>;

    if (!bodyJson.containsKey('daily')) {
      throw WeatherNotFoundFailure();
    }

    final dailyJson = bodyJson['daily'] as Map<String, dynamic>;
    final tempertureList = dailyJson['temperature_2m_max'];
    final weathercodeList = dailyJson['weathercode'];
    final dateList = dailyJson['time'];

    // Map<String, String> combinedMap =
    final listLength = tempertureList.length;

    List<Weather> weatherList = List.generate(
      listLength,
      (index) => Weather.fromJson(
        {
          'temperature': tempertureList[index],
          'weathercode': weathercodeList[index],
          'applicable_date': dateList[index],
        },
      ),
    );
    return weatherList;
  }
}
