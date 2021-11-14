import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:minimal_weather/weather/weather.dart';
import 'package:weather_repository/weather_repository.dart' hide Weather;
import 'package:weather_repository/weather_repository.dart'
    as weather_repository;

void main() {
  group('Weather', () {
    final weather = Weather(
        condition: WeatherCondition.clear,
        lastUpdated: DateTime.parse('2021-11-12'),
        location: 'London',
        temperature: const Temperature(value: 74),
        date: DateTime.parse('2021-11-12 13:27:00'));
    final weatherFromRepository = weather_repository.Weather(
        location: 'London',
        temperature: 74,
        condition: WeatherCondition.clear,
        date: DateTime.parse('2021-11-12 13:27:00'));

    group('from json', () {
      test('return weather from json', () {
        expect(
            Weather.fromJson(const <String, dynamic>{
              'condition': 'clear',
              'last_updated': '2021-11-12T00:00:00.000',
              'location': 'London',
              'temperature': {'value': 74},
              'date': '2021-11-12 13:27:00'
            }),
            weather);
      });
      test('throw CheckedFromJsonException when value is null', () {
        expect(
          () => Weather.fromJson(<String, dynamic>{
            'condition': WeatherCondition.clear,
            'last_updated': DateTime.parse('2021-11-12'),
            'location': 'London',
            'temperature': null,
            'date': DateTime.parse('2021-11-12 13:27:00')
          }),
          throwsA(isA<CheckedFromJsonException>()),
        );
      });
      test('throw CheckedFromJsonException when key is unknown', () {
        expect(
          () => Weather.fromJson(<String, dynamic>{
            'condition': WeatherCondition.clear,
            'last_updated': DateTime.parse('2021-11-12'),
            'location': 'London',
            'lalala': const Temperature(value: 74),
            'date': DateTime.parse('2021-11-12 13:27:00')
          }),
          throwsA(isA<CheckedFromJsonException>()),
        );
      });
    });

    test('to json', () {
      expect(weather.toJson(), <String, dynamic>{
        'condition': 'clear',
        'last_updated': '2021-11-12T00:00:00.000',
        'location': 'London',
        'temperature': const Temperature(value: 74),
        'date': '2021-11-12T13:27:00.000'
      });
    });

    group('from repository', () {
      test('return Weather from repository', () {
        expect(Weather.fromRepository(weatherFromRepository),
            isA<Weather>().having((w) => w.location, 'location', 'London'));
      });
    });

    test('copy with', () {
      expect(
          weather.copyWith(
              condition: WeatherCondition.clear,
              lastUpdated: DateTime.parse('2021-11-12'),
              location: 'London',
              temperature: const Temperature(value: 74),
              date: DateTime.parse('2021-11-12 13:27:00')),
          weather);
    });
  });
  group('Temperature', () {
    const temp = Temperature(value: 74);

    test('from json', () {
      expect(Temperature.fromJson(const <String, dynamic>{'value': 74}), temp);
    });
    test('from json', () {
      expect(temp.toJson(), const <String, dynamic>{'value': 74});
    });
  });
}
