// ignore_for_file: always_use_package_imports

import 'package:get_it/get_it.dart';
import 'package:minimal_weather/weather_status/data/repositories/weather_repository_impl.dart';
import 'package:minimal_weather/weather_status/domain/repositories/weather_repository.dart';
import 'package:minimal_weather/weather_status/presentation/controller/weather_cubit.dart';

import 'weather_status/data/datasource/weather_datasource.dart';
import 'weather_status/domain/usecases/weather_usecase.dart';

void registerDependencies() {
  final getIt = GetIt.I;

  getIt
    ..registerLazySingleton<IWeatherUsecase>(
      () => WeatherUsecase(
        getIt(),
      ),
    )
    ..registerLazySingleton<IWeatherRepository>(
      () => WeatherRepository(
        getIt(),
      ),
    )
    ..registerLazySingleton<IWeatherDataSource>(
      () => WeatherDataSource(),
    )
    ..registerLazySingleton<WeatherController>(
      () => WeatherController(
        WeatherUsecase(
          getIt(),
        ),
      ),
    );
}
