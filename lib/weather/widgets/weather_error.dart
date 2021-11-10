import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherError extends StatelessWidget {
  const WeatherError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('assets/states/error.json', width: 200),
        Text(
          'Something went wrong',
          style: theme.textTheme.headline2,
        ),
        Text(
          'Please try again',
          style: theme.textTheme.headline2,
        ),
      ],
    );
  }
}
