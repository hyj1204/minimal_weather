import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_repository/src/models/models.dart';

void main() {
  group('Weather in repository', () {
    final weather = Weather(
        location: 'London',
        temperature: 14.14,
        condition: WeatherCondition.clear,
        date: DateTime.parse('2021-11-12'));
    group('fromJson', () {
      test('return a Weather from json', () {
        expect(
            Weather.fromJson(const <String, dynamic>{
              'location': 'London',
              'temperature': 14.14,
              'condition': 'clear',
              'date': '2021-11-12'
            }),
            isA<Weather>());
      });
      test('return WeatherCondition.unknown when condition is unknown ', () {
        expect(
            Weather.fromJson(const <String, dynamic>{
              'location': 'London',
              'temperature': 14.14,
              'condition': 'lalala',
              'date': '2021-11-12'
            }),
            isA<Weather>().having(
                (w) => w.condition, 'condition', WeatherCondition.unknown));
      });

      test('throw CheckedFromJsonException when json key is unknown', () {
        expect(
          () => Weather.fromJson(const <String, dynamic>{
            'location': 'London',
            'temperature': 14.14,
            'lalalala': 'clear',
            'date': '2021-11-12'
          }),
          throwsA(isA<CheckedFromJsonException>()),
        );
      });
    });

    test('toJson', () {
      expect(weather.toJson(), const <String, dynamic>{
        'location': 'London',
        'temperature': 14.14,
        'condition': 'clear',
        'date': '2021-11-12T00:00:00.000'
      });
    });
  });
}
