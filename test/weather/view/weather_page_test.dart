// // ignore_for_file: prefer_single_quotes, prefer_const_constructors

// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_test/flutter_test.dart';
// // import 'package:meta_weather_api/meta_weather_api.dart' as api;
// import 'package:minimal_weather/l10n/l10n.dart';
// import 'package:minimal_weather/weather/weather.dart';
// import 'package:minimal_weather/weather/widgets/widgets.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:weather_repository/weather_repository.dart'
//     as weather_repositroy;

// import '../../helpers/hydrated_bloc.dart';

// class MockWeatherRepository extends Mock
//     implements weather_repositroy.WeatherRepository {}

// class FakeWeatherState extends Fake implements WeatherState {}

// class MockWeatherCubit extends MockCubit<WeatherState> implements WeatherCubit {
// }

// class _L10nTest extends StatelessWidget {
//   const _L10nTest(this.widget);
//   final Widget widget;

//   @override
//   Widget build(BuildContext context) {
//     return MediaQuery(
//       data: MediaQueryData(),
//       child: MaterialApp(
//         home: widget,
//         localizationsDelegates: const [
//           AppLocalizations.delegate,
//           GlobalMaterialLocalizations.delegate,
//         ],
//       ),
//     );
//   }
// }

// void main() {
//   initHydratedStorage();

//   setUpAll(() {
//     registerFallbackValue(FakeWeatherState());
//   });

//   group('weather page', () {
//     late weather_repositroy.WeatherRepository weatherRepository;

//     setUp(() {
//       weatherRepository = MockWeatherRepository();
//     });

//     testWidgets('renders WeatherView', (tester) async {
//       await tester.pumpWidget(
//         RepositoryProvider.value(
//           value: weatherRepository,
//           //for l10n
//           child: _L10nTest(WeatherPage()),
//         ),
//       );

//       expect(find.byType(WeatherView), findsOneWidget);
//     });

//     group('WeatherView', () {
//       final jsonWeatherList = [
//         <String, dynamic>{
//           "id": 4645021635575808,
//           "weather_state_name": "Heavy Cloud",
//           "weather_state_abbr": "hc",
//           "wind_direction_compass": "NNE",
//           "created": "2021-11-14T03:59:01.949896Z",
//           "applicable_date": "2021-11-14",
//           "min_temp": 9.08,
//           "max_temp": 13.46,
//           "the_temp": 12.515,
//           "wind_speed": 5.863994722736552,
//           "wind_direction": 11.61143624889906,
//           "air_pressure": 1024,
//           "humidity": 81,
//           "visibility": 9.132913783504335,
//           "predictability": 71
//         },
//         {
//           "id": 6469095294763008,
//           "weather_state_name": "Light Cloud",
//           "weather_state_abbr": "lc",
//           "wind_direction_compass": "NE",
//           "created": "2021-11-14T03:59:01.883782Z",
//           "applicable_date": "2021-11-15",
//           "min_temp": 7.1850000000000005,
//           "max_temp": 12.379999999999999,
//           "the_temp": 11.61,
//           "wind_speed": 3.1547751429147115,
//           "wind_direction": 37.699240041185625,
//           "air_pressure": 1026.5,
//           "humidity": 77,
//           "visibility": 10.628243557623477,
//           "predictability": 70
//         },
//         {
//           "id": 4906474414276608,
//           "weather_state_name": "Heavy Cloud",
//           "weather_state_abbr": "hc",
//           "wind_direction_compass": "WSW",
//           "created": "2021-11-14T03:59:01.873771Z",
//           "applicable_date": "2021-11-16",
//           "min_temp": 6.575,
//           "max_temp": 11.67,
//           "the_temp": 10.525,
//           "wind_speed": 3.967767678374294,
//           "wind_direction": 251.478220293452,
//           "air_pressure": 1022.5,
//           "humidity": 78,
//           "visibility": 12.603893263342082,
//           "predictability": 71
//         },
//         {
//           "id": 5481816153653248,
//           "weather_state_name": "Heavy Cloud",
//           "weather_state_abbr": "hc",
//           "wind_direction_compass": "W",
//           "created": "2021-11-14T03:59:02.357631Z",
//           "applicable_date": "2021-11-17",
//           "min_temp": 7.2,
//           "max_temp": 11.695,
//           "the_temp": 10.895,
//           "wind_speed": 5.708150282040882,
//           "wind_direction": 281.20096516131207,
//           "air_pressure": 1023,
//           "humidity": 74,
//           "visibility": 13.108757357034916,
//           "predictability": 71
//         },
//         {
//           "id": 4827073555202048,
//           "weather_state_name": "Heavy Cloud",
//           "weather_state_abbr": "hc",
//           "wind_direction_compass": "WSW",
//           "created": "2021-11-14T03:59:03.544197Z",
//           "applicable_date": "2021-11-18",
//           "min_temp": 5.105,
//           "max_temp": 11.465,
//           "the_temp": 11.66,
//           "wind_speed": 4.57625312427689,
//           "wind_direction": 256.83406201695544,
//           "air_pressure": 1028,
//           "humidity": 80,
//           "visibility": 12.704866082080649,
//           "predictability": 71
//         },
//         {
//           "id": 5770921542418432,
//           "weather_state_name": "Light Cloud",
//           "weather_state_abbr": "lc",
//           "wind_direction_compass": "WSW",
//           "created": "2021-11-14T03:59:04.978840Z",
//           "applicable_date": "2021-11-19",
//           "min_temp": 6.390000000000001,
//           "max_temp": 13.98,
//           "the_temp": 13.88,
//           "wind_speed": 3.605895569871948,
//           "wind_direction": 250,
//           "air_pressure": 1030,
//           "humidity": 80,
//           "visibility": 9.999726596675416,
//           "predictability": 70
//         }
//       ];
//       final tempWeatherList =
//           jsonWeatherList.map((e) => api.Weather.fromJson(e)).toList();
//       final weatherList = tempWeatherList
//           .map((e) => Weather(
//                 location: 'London',
//                 lastUpdated: DateTime(2020),
//                 temperature: Temperature(value: e.theTemp),
//                 condition: WeatherCondition.thundery,
//                 date: e.applicableDate,
//               ))
//           .toList();

//       late WeatherCubit weatherCubit;

//       setUp(() {
//         weatherCubit = MockWeatherCubit();
//       });

//       testWidgets('renders WeatherEmpty for WeatherStatus.initial',
//           (tester) async {
//         when(() => weatherCubit.state).thenReturn(WeatherState());
//         await tester.pumpWidget(BlocProvider.value(
//           value: weatherCubit,
//           child: _L10nTest(WeatherView()),
//         ));
//         expect(find.byType(WeatherEmpty), findsOneWidget);
//       });
//       testWidgets('renders WeatherLoading for WeatherStatus.loading',
//           (tester) async {
//         when(() => weatherCubit.state).thenReturn(WeatherState(
//           status: WeatherStatus.loading,
//         ));
//         await tester.pumpWidget(BlocProvider.value(
//           value: weatherCubit,
//           child: _L10nTest(WeatherView()),
//         ));
//         expect(find.byType(WeatherLoading), findsOneWidget);
//       });
//       testWidgets('renders WeatherPopulated for WeatherStatus.success',
//           (tester) async {
//         when(() => weatherCubit.state).thenReturn(WeatherState(
//           status: WeatherStatus.success,
//           weatherList: weatherList,
//         ));
//         await tester.pumpWidget(BlocProvider.value(
//           value: weatherCubit,
//           child: _L10nTest(WeatherView()),
//         ));
//         expect(find.byType(WeatherPopulated), findsOneWidget);
//       });
//       testWidgets('renders WeatherError for WeatherStatus.failure',
//           (tester) async {
//         when(() => weatherCubit.state).thenReturn(WeatherState(
//           status: WeatherStatus.failure,
//         ));
//         await tester.pumpWidget(BlocProvider.value(
//           value: weatherCubit,
//           child: _L10nTest(WeatherView()),
//         ));
//         expect(find.byType(WeatherError), findsOneWidget);
//       });

//       testWidgets('triggers refreshWeather on pull to refresh', (tester) async {
//         when(() => weatherCubit.state).thenReturn(WeatherState(
//           status: WeatherStatus.success,
//           weatherList: weatherList,
//         ));
//         when(() => weatherCubit.refreshWeather()).thenAnswer((_) async {});
//         await tester.pumpWidget(BlocProvider.value(
//           value: weatherCubit,
//           child: _L10nTest(WeatherView()),
//         ));
//         await tester.timedDrag(
//           find.text('London'),
//           const Offset(0, 100),
//           Duration(seconds: 1),
//         );
//         await tester.pump(Duration(seconds: 2));
//         verify(() => weatherCubit.refreshWeather()).called(1);
//       });
//       testWidgets('triggers fetch weather when search button is tapped',
//           (tester) async {
//         when(() => weatherCubit.state).thenReturn(WeatherState());
//         when(() => weatherCubit.fetchWeather(any())).thenAnswer((_) async {});
//         await tester.pumpWidget(BlocProvider.value(
//           value: weatherCubit,
//           child: _L10nTest(WeatherView()),
//         ));
//         await tester.tap(find.byKey(Key('search_button')));
//         await tester.pump(Duration(seconds: 1));
//         await tester.enterText(find.byType(TextField), 'Chicago');
//         await tester.testTextInput.receiveAction(TextInputAction.done);
//         await tester.pump(Duration(seconds: 1));
//         verify(() => weatherCubit.fetchWeather('Chicago')).called(1);
//       });
//       testWidgets('triggers switch unit when unit button is tapped',
//           (tester) async {
//         when(() => weatherCubit.state).thenReturn(WeatherState());
//         when(() => weatherCubit.fetchWeather(any())).thenAnswer((_) async {});
//         await tester.pumpWidget(BlocProvider.value(
//           value: weatherCubit,
//           child: _L10nTest(WeatherView()),
//         ));
//         await tester.tap(find.byKey(Key('unit_button')));
//         await tester.pump(Duration(seconds: 1));
//         verify(() => weatherCubit.toggleUnits()).called(1);
//       });
//     });
//   });
// }
