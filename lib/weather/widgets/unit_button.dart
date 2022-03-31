// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimal_weather/weather_status/domain/entities/temperature_entity.dart';
import '../../weather_status/presentation/controller/weather_cubit.dart';

class UnitButton extends StatelessWidget {
  const UnitButton({Key? key, required this.controller}) : super(key: key);
  final WeatherController controller;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider.value(
      value: controller,
      child: BlocBuilder<WeatherController, WeatherState>(
          builder: (context, state) {
        return TextButton(
          key: const Key('unit_button'),
          onPressed: controller.toggleUnits,
          child: Text(
            state.temperatureUnits.isCelsius ? '°C' : '°F',
            style: theme.textTheme.bodyText1,
          ),
        );
      }),
    );
  }
}
