import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherEmpty extends StatelessWidget {
  const WeatherEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('assets/states/empty.json', width: 300),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Please search a city',
          style: theme.textTheme.headline2,
        ),
      ],
    );
  }
}
