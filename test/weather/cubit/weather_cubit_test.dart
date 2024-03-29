import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:minimal_weather/weather/weather.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_repository/weather_repository.dart'
    as weather_repository;

import '../../helpers/hydrated_bloc.dart';

const weatherLocation = 'London';
const weatherCondition = weather_repository.WeatherCondition.rainy;
const weatherTemperature = 9.8;
final weatherDate = DateTime(2021, 11, 8);

class MockWeatherRepository extends Mock
    implements weather_repository.WeatherRepository {}

class MockWeather extends Mock implements weather_repository.Weather {}

void main() {
  initHydratedStorage();
  group('WeatherCubit', () {
    late weather_repository.Weather weather;
    late weather_repository.WeatherRepository weatherRepository;

    // setUpAll(initHydratedBloc);

    setUp(() {
      weather = MockWeather();
      weatherRepository = MockWeatherRepository();
      when(() => weather.location).thenReturn(weatherLocation);
      when(() => weather.temperature).thenReturn(weatherTemperature);
      when(() => weather.condition).thenReturn(weatherCondition);
      when(() => weather.date).thenReturn(weatherDate);
      when(
        () => weatherRepository.getWeatherList(any()),
      ).thenAnswer((_) async => [weather]);
    });

    test('initial state is correct', () {
      final weatherCubit = WeatherCubit(weatherRepository);
      expect(weatherCubit.state, const WeatherState());
    });

    test("throw CheckedFromJsonException when state's status is unknown", () {
      expect(
          () => WeatherState.fromJson(<String, dynamic>{
                'status': 'lalala',
                'weatherList': [weather],
                'temperatureUnits': TemperatureUnits.fahrenheit,
              }),
          throwsA(isA<CheckedFromJsonException>()));
    });

    test('throw CheckedFromJsonException when unit is unknown', () {
      expect(
          () => WeatherState.fromJson(<String, dynamic>{
                'status': WeatherStatus.success,
                'weatherList': [weather],
                'temperatureUnits': TemperatureUnits,
              }),
          throwsA(isA<CheckedFromJsonException>()));
    });
    test('throw CheckedFromJsonException when json is empty', () {
      expect(() => WeatherState.fromJson(const <String, dynamic>{}),
          throwsA(isA<CheckedFromJsonException>()));
    });

    group('toJson/fromJson', () {
      test('work properly', () {
        final weatherCubit = WeatherCubit(weatherRepository);
        expect(
          weatherCubit.fromJson(weatherCubit.toJson(weatherCubit.state)),
          weatherCubit.state,
        );
      });
    });

    group('fetchWeather', () {
      blocTest<WeatherCubit, WeatherState>(
        'emits nothing when city is null',
        build: () => WeatherCubit(weatherRepository),
        act: (cubit) => cubit.fetchWeather(null),
        expect: () => <WeatherState>[],
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits nothing when city is empty',
        build: () => WeatherCubit(weatherRepository),
        act: (cubit) => cubit.fetchWeather(''),
        expect: () => <WeatherState>[],
      );

      blocTest<WeatherCubit, WeatherState>(
        'calls getWeather with correct city',
        build: () => WeatherCubit(weatherRepository),
        act: (cubit) => cubit.fetchWeather(weatherLocation),
        verify: (_) {
          verify(() => weatherRepository.getWeatherList(weatherLocation))
              .called(1);
        },
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits [loading, failure] when getWeather throws',
        setUp: () {
          when(
            () => weatherRepository.getWeatherList(any()),
          ).thenThrow(Exception('oops'));
        },
        build: () => WeatherCubit(weatherRepository),
        act: (cubit) => cubit.fetchWeather(weatherLocation),
        expect: () => <WeatherState>[
          const WeatherState(status: WeatherStatus.loading),
          const WeatherState(status: WeatherStatus.failure),
        ],
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits [loading, success] when getWeather returns (celsius)',
        build: () => WeatherCubit(weatherRepository),
        act: (cubit) => cubit.fetchWeather(weatherLocation),
        expect: () => <dynamic>[
          const WeatherState(status: WeatherStatus.loading),
          isA<WeatherState>()
              .having((w) => w.status, 'status', WeatherStatus.success)
              .having(
                  (w) => w.weatherList.first,
                  'weather',
                  isA<Weather>()
                      .having((w) => w.lastUpdated, 'lastUpdated', isNotNull)
                      .having((w) => w.condition, 'condition', weatherCondition)
                      .having(
                        (w) => w.temperature,
                        'temperature',
                        const Temperature(value: weatherTemperature),
                      )
                      .having((w) => w.location, 'location', weatherLocation)
                      .having((w) => w.date, 'date', weatherDate))
        ],
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits [loading, success] when getWeather returns (fahrenheit)',
        build: () => WeatherCubit(weatherRepository),
        seed: () =>
            const WeatherState(temperatureUnits: TemperatureUnits.fahrenheit),
        act: (cubit) => cubit.fetchWeather(weatherLocation),
        expect: () => <dynamic>[
          const WeatherState(
            status: WeatherStatus.loading,
            temperatureUnits: TemperatureUnits.fahrenheit,
          ),
          isA<WeatherState>()
              .having((w) => w.status, 'status', WeatherStatus.success)
              .having(
                (w) => w.weatherList.first,
                'weather',
                isA<Weather>()
                    .having((w) => w.lastUpdated, 'lastUpdated', isNotNull)
                    .having((w) => w.condition, 'condition', weatherCondition)
                    .having(
                      (w) => w.temperature,
                      'temperature',
                      Temperature(value: weatherTemperature.toFahrenheit()),
                    )
                    .having((w) => w.location, 'location', weatherLocation)
                    .having((w) => w.date, 'date', weatherDate),
              ),
        ],
      );
    });

    group('refreshWeather', () {
      blocTest<WeatherCubit, WeatherState>(
        'emits nothing when status is not success',
        build: () => WeatherCubit(weatherRepository),
        act: (cubit) => cubit.refreshWeather(),
        expect: () => <WeatherState>[],
        verify: (_) {
          verifyNever(() => weatherRepository.getWeatherList(any()));
        },
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits nothing when location is null',
        build: () => WeatherCubit(weatherRepository),
        seed: () => const WeatherState(status: WeatherStatus.success),
        act: (cubit) => cubit.refreshWeather(),
        expect: () => <WeatherState>[],
        verify: (_) {
          verifyNever(() => weatherRepository.getWeatherList(any()));
        },
      );

      blocTest<WeatherCubit, WeatherState>(
        'invokes getWeather with correct location',
        build: () => WeatherCubit(weatherRepository),
        seed: () => WeatherState(status: WeatherStatus.success, weatherList: [
          Weather(
              location: weatherLocation,
              temperature: const Temperature(value: weatherTemperature),
              lastUpdated: DateTime(2020),
              condition: weatherCondition,
              date: DateTime(2021)),
          Weather(
              location: weatherLocation,
              temperature: const Temperature(value: weatherTemperature + 1),
              lastUpdated: DateTime(2020),
              condition: weatherCondition,
              date: DateTime(2021)),
        ]),
        act: (cubit) => cubit.refreshWeather(),
        verify: (_) {
          verify(() => weatherRepository.getWeatherList(weatherLocation))
              .called(1);
        },
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits nothing when exception is thrown',
        setUp: () {
          when(
            () => weatherRepository.getWeatherList(any()),
          ).thenThrow(Exception('oops'));
        },
        build: () => WeatherCubit(weatherRepository),
        seed: () => WeatherState(status: WeatherStatus.success, weatherList: [
          Weather(
              location: weatherLocation,
              temperature: const Temperature(value: weatherTemperature),
              lastUpdated: DateTime(2020),
              condition: weatherCondition,
              date: DateTime(2021)),
          Weather(
              location: weatherLocation,
              temperature: const Temperature(value: weatherTemperature + 1),
              lastUpdated: DateTime(2020),
              condition: weatherCondition,
              date: DateTime(2021)),
        ]),
        act: (cubit) => cubit.refreshWeather(),
        expect: () => <WeatherState>[],
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits updated weather (celsius)',
        build: () => WeatherCubit(weatherRepository),
        seed: () => WeatherState(status: WeatherStatus.success, weatherList: [
          Weather(
            location: weatherLocation,
            temperature: const Temperature(value: 70),
            lastUpdated: DateTime(2020),
            condition: weatherCondition,
            date: DateTime(2021),
          ),
        ]),
        act: (cubit) => cubit.refreshWeather(),
        expect: () => <Matcher>[
          isA<WeatherState>()
              .having((w) => w.status, 'status', WeatherStatus.success)
              .having(
                (w) => w.weatherList.first,
                'weather',
                isA<Weather>()
                    .having((w) => w.lastUpdated, 'lastUpdated', isNotNull)
                    .having((w) => w.condition, 'condition', weatherCondition)
                    .having(
                      (w) => w.temperature,
                      'temperature',
                      const Temperature(value: weatherTemperature),
                    )
                    .having((w) => w.location, 'location', weatherLocation)
                    .having((w) => w.date, 'date', weatherDate),
              ),
        ],
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits updated weather (fahrenheit)',
        build: () => WeatherCubit(weatherRepository),
        seed: () => WeatherState(
            temperatureUnits: TemperatureUnits.fahrenheit,
            status: WeatherStatus.success,
            weatherList: [
              Weather(
                location: weatherLocation,
                temperature: const Temperature(value: 80),
                lastUpdated: DateTime(2020),
                condition: weatherCondition,
                date: DateTime(2021),
              ),
            ]),
        act: (cubit) => cubit.refreshWeather(),
        expect: () => <Matcher>[
          isA<WeatherState>()
              .having((w) => w.status, 'status', WeatherStatus.success)
              .having(
                (w) => w.weatherList.first,
                'weather',
                isA<Weather>()
                    .having((w) => w.lastUpdated, 'lastUpdated', isNotNull)
                    .having((w) => w.condition, 'condition', weatherCondition)
                    .having(
                      (w) => w.temperature,
                      'temperature',
                      Temperature(value: weatherTemperature.toFahrenheit()),
                    )
                    .having((w) => w.location, 'location', weatherLocation)
                    .having((w) => w.date, 'date', weatherDate),
              ),
        ],
      );
    });

    group('toggleUnits', () {
      blocTest<WeatherCubit, WeatherState>(
        'emits updated units when status is not success',
        build: () => WeatherCubit(weatherRepository),
        act: (cubit) => cubit.toggleUnits(),
        expect: () => <WeatherState>[
          const WeatherState(temperatureUnits: TemperatureUnits.fahrenheit),
        ],
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits updated units and temperature '
        'when status is success (celsius)',
        build: () => WeatherCubit(weatherRepository),
        seed: () => WeatherState(
            status: WeatherStatus.success,
            temperatureUnits: TemperatureUnits.fahrenheit,
            weatherList: [
              Weather(
                location: weatherLocation,
                temperature: const Temperature(value: weatherTemperature),
                lastUpdated: DateTime(2020),
                condition: WeatherCondition.rainy,
                date: DateTime(2021),
              ),
            ]),
        act: (cubit) => cubit.toggleUnits(),
        expect: () => <WeatherState>[
          WeatherState(status: WeatherStatus.success, weatherList: [
            Weather(
              location: weatherLocation,
              temperature: Temperature(value: weatherTemperature.toCelsius()),
              lastUpdated: DateTime(2020),
              condition: WeatherCondition.rainy,
              date: DateTime(2021),
            ),
          ]),
        ],
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits updated units and temperature '
        'when status is success (fahrenheit)',
        build: () => WeatherCubit(weatherRepository),
        seed: () => WeatherState(status: WeatherStatus.success, weatherList: [
          Weather(
            location: weatherLocation,
            temperature: const Temperature(value: weatherTemperature),
            lastUpdated: DateTime(2020),
            condition: WeatherCondition.rainy,
            date: DateTime(2021),
          ),
        ]),
        act: (cubit) => cubit.toggleUnits(),
        expect: () => <WeatherState>[
          WeatherState(
              status: WeatherStatus.success,
              temperatureUnits: TemperatureUnits.fahrenheit,
              weatherList: [
                Weather(
                  location: weatherLocation,
                  temperature: Temperature(
                    value: weatherTemperature.toFahrenheit(),
                  ),
                  lastUpdated: DateTime(2020),
                  condition: WeatherCondition.rainy,
                  date: DateTime(2021),
                ),
              ]),
        ],
      );
    });
  });
}

extension on double {
  double toFahrenheit() => (this * 9 / 5) + 32;
  double toCelsius() => (this - 32) * 5 / 9;
}
