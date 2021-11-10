import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherLoading extends StatelessWidget {
  const WeatherLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/states/loading.json',
          width: 300,
        ),
        Text(
          'Loading',
          style: theme.textTheme.headline2,
        ),
      ],
    );
  }
}
