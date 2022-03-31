import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:minimal_weather/l10n/l10n.dart';

class WeatherError extends StatelessWidget {
  const WeatherError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('assets/states/error.json', width: 200),
        Text(
          l10n.weatherErrorTitle1,
          style: theme.textTheme.headline2,
        ),
        Text(
          l10n.weatherErrorTitle2,
          style: theme.textTheme.headline2,
        ),
      ],
    );
  }
}
