// ignore_for_file: avoid_void_async

import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:minimal_weather/app/app.dart';
import 'package:minimal_weather/weather_bloc_observer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weather_repository/weather_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };
  final storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

  HydratedBlocOverrides.runZoned(
    () {
      runZonedGuarded(
        () => runApp(WeatherApp(weatherRepository: WeatherRepository())),
        (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
      );
    },
    blocObserver: WeatherBlocObserver(),
    storage: storage,
  );
}
