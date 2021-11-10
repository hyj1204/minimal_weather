import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:minimal_weather/l10n/l10n.dart';

class WeatherEmpty extends StatelessWidget {
  const WeatherEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('assets/states/empty.json', width: 300),
        const SizedBox(
          height: 10,
        ),
        Text(
          l10n.weatherEmptyTitle,
          style: theme.textTheme.headline2,
        ),
      ],
    );
  }
}
