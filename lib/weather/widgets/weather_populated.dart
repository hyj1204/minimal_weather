import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:minimal_weather/app/constants.dart';
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

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _TodayWeather(
              weather: weatherList[0],
              units: units,
            ),
            Flexible(
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 5),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: weatherList.length - 1,
                itemBuilder: (context, index) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        DateFormat.MMMEd().format(weatherList[index + 1].date),
                        style: theme.textTheme.headline2,
                      ),
                      _WeatherIcon(
                        condition: weatherList[index + 1].condition,
                        size: 50,
                      ),
                      Text(
                        weatherList[index + 1].formattedTemperature(units),
                        style: theme.textTheme.headline2,
                      ),
                    ]),
              ),
            ),
          ],
        ),
      )),
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
      children: [
        Text(
          weather.location,
          style: theme.textTheme.headline1,
        ),
        Text(
          'Today',
          style: theme.textTheme.headline2,
        ),
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
