// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:minimal_weather/l10n/l10n.dart';

import '../../../domain/entities/temperature_entity.dart';
import '../../../domain/entities/weather_entity.dart';

class WeatherPopulated extends StatelessWidget {
  const WeatherPopulated({
    Key? key,
    required this.weatherList,
    required this.units,
    required this.onRefresh,
  }) : super(key: key);

  final List<Weather> weatherList;
  final TemperatureUnits units;
  final ValueGetter<Future<void>> onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 120, 0, 0),
      child: RefreshIndicator(
        color: theme.backgroundColor,
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _TodayWeather(
                weather: weatherList[0],
                units: units,
              ),
              _FutureWeather(weatherList: weatherList, units: units),
              Text(
                '''${l10n.weatherPopulatedTitle} ${TimeOfDay.fromDateTime(weatherList.first.lastUpdated).format(context)}''',
                style: theme.textTheme.headline2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FutureWeather extends StatelessWidget {
  const _FutureWeather({
    Key? key,
    required this.weatherList,
    required this.units,
  }) : super(key: key);

  final List<Weather> weatherList;
  final TemperatureUnits units;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return ListView.builder(
        shrinkWrap: true,
        itemCount: weatherList.length - 1,
        itemBuilder: (context, index) => ListTile(
              leading: SizedBox(
                width: size.width * 0.47,
                child: Text(
                    DateFormat.MMMEd().format(weatherList[index + 1].date),
                    style: theme.textTheme.bodyText1),
              ),
              title: _WeatherIcon(
                condition: weatherList[index + 1].condition,
                size: 48,
              ),
              trailing: Text(
                weatherList[index + 1].formattedTemperature(units),
                style: theme.textTheme.bodyText1,
                textAlign: TextAlign.left,
              ),
            ));
  }
}

class _TodayWeather extends StatelessWidget {
  const _TodayWeather({
    Key? key,
    required this.weather,
    required this.units,
  }) : super(key: key);

  final Weather weather;
  final TemperatureUnits units;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          weather.location,
          style: theme.textTheme.headline1,
        ),
        Text(
          'Today',
          style: theme.textTheme.headline2,
        ),
        const SizedBox(height: 20),
        _WeatherIcon(
          condition: weather.condition,
          size: 100,
        ),
        Text(
          weather.formattedTemperature(units),
          style: theme.textTheme.headline1,
        ),
      ],
    );
  }
}

class _WeatherIcon extends StatelessWidget {
  const _WeatherIcon({Key? key, required this.condition, required this.size})
      : super(key: key);

  final WeatherCondition condition;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(condition.toLottie,
        width: size, height: size, alignment: Alignment.centerLeft);
  }
}

extension on WeatherCondition {
  String get toLottie {
    switch (this) {
      case WeatherCondition.clear:
        return 'assets/condition_lotties/clear.json';
      case WeatherCondition.rainy:
        return 'assets/condition_lotties/rainy.json';
      case WeatherCondition.cloudy:
        return 'assets/condition_lotties/cloudy.json';
      case WeatherCondition.snowy:
        return 'assets/condition_lotties/snowy.json';
      case WeatherCondition.thundery:
        return 'assets/condition_lotties/thundery.json';
      case WeatherCondition.unknown:
      default:
        return ' ';
    }
  }
}

extension on Weather {
  String formattedTemperature(TemperatureUnits units) {
    return '''${temperature.value.toStringAsPrecision(2)}°${units.isCelsius ? 'C' : 'F'}''';
  }
}
