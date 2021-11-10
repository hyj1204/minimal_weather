import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:minimal_weather/weather/weather.dart';

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

    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 120, 5, 0),
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
              _FutureWeather(
                  weatherList: weatherList, theme: theme, units: units),
              Text(
                '''Last Updated at ${TimeOfDay.fromDateTime(weatherList.first.lastUpdated).format(context)}''',
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
    required this.theme,
    required this.units,
  }) : super(key: key);

  final List<Weather> weatherList;
  final ThemeData theme;
  final TemperatureUnits units;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ListView.separated(
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: weatherList.length - 1,
            itemBuilder: (context, index) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 140,
                    child: Text(
                      DateFormat.MMMEd().format(weatherList[index + 1].date),
                      style: theme.textTheme.headline2,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ]),
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: weatherList.length - 1,
            itemBuilder: (context, index) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 50,
                    child: _WeatherIcon(
                      condition: weatherList[index + 1].condition,
                      size: 50,
                    ),
                  ),
                ]),
          ),
        ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: weatherList.length - 1,
            itemBuilder: (context, index) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      weatherList[index + 1].formattedTemperature(units),
                      style: theme.textTheme.headline2,
                    ),
                  ),
                ]),
          ),
        ),
      ],
    );
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
    return Lottie.asset(condition.toLottie, width: size, height: size);
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
        return '❓';
    }
  }
}

extension on Weather {
  String formattedTemperature(TemperatureUnits units) {
    return '''${temperature.value.toStringAsPrecision(2)}°${units.isCelsius ? 'C' : 'F'}''';
  }
}
