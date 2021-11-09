import 'package:flutter/material.dart';

class WeatherEmpty extends StatelessWidget {
  const WeatherEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: get current location weather info
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🏙️', style: TextStyle(fontSize: 64)),
            Text(
              'Please Select a City!',
              style: theme.textTheme.headline1,
            ),
          ],
        ),
      ),
    );
  }
}
