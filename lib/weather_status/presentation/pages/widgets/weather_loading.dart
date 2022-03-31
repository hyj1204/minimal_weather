import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:minimal_weather/l10n/l10n.dart';

class WeatherLoading extends StatelessWidget {
  const WeatherLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/states/loading.json',
          width: 300,
        ),
        Text(
          l10n.weatherLoadingTitle,
          style: theme.textTheme.headline2,
        ),
      ],
    );
  }
}
