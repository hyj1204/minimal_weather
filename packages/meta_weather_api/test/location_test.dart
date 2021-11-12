import 'package:json_annotation/json_annotation.dart';
import 'package:meta_weather_api/meta_weather_api.dart';
import 'package:test/test.dart';

void main() {
  const latlng = LatLng(latitude: -34.75, longitude: 83.28);
  const coverter = LatLngConverter();
  const latlngString = '-34.75,83.28';
  group('Location', () {
    group('fromJson', () {
      test('throws CheckedFromJsonException when location type is null', () {
        expect(
          () => {
            Location.fromJson(<String, dynamic>{
              'title': 'mock-title',
              'location_type': null,
              'latt_long': latlngString,
              'woeid': 42
            })
          },
          throwsA(isA<CheckedFromJsonException>()),
        );
      });

      test(
          'return LocationType.unknown when location_type doesn\'t belong to the pre-set locaiton type',
          () {
        expect(
            Location.fromJson(<String, dynamic>{
              'title': 'mock-title',
              'location_type': 'lalala',
              'latt_long': latlngString,
              'woeid': 42
            }),
            isA<Location>().having(
                (l) => l.locationType, 'locationType', LocationType.unknown));
      });

      test('throw CheckedFromJsonException when json key is unknown', () {
        expect(
          () => Location.fromJson(<String, dynamic>{
            'title': 'mock-title',
            'lalala': 'City',
            'latt_long': latlngString,
            'woeid': 42
          }),
          throwsA(isA<CheckedFromJsonException>()),
        );
      });

      test('return Location has the same property from Json ', () {
        expect(
            Location.fromJson(<String, dynamic>{
              'title': 'Austin',
              'location_type': 'City',
              'latt_long': latlngString,
              'woeid': 42
            }),
            isA<Location>()
                .having(
                    (l) => l.locationType, 'locationType', LocationType.city)
                .having((l) => l.title, 'title', 'Austin')
                .having((l) => l.woeid, 'woeid', 42));
      });
    });
  });
  group('LatLng', () {
    group('toJson', () {
      test('return {-34.75,83.28} after coverter toJson', () {
        expect(coverter.toJson(latlng), latlngString);
      });
    });
    group('fromJson', () {
      test('return a LatLng when converter from json', () {
        expect(coverter.fromJson(latlngString), isA<LatLng>());
      });
      test('throw ArgumentError when string is not LatLng format', () {
        expect(() => coverter.fromJson('hello'), throwsArgumentError);
      });
    });
  });
}
