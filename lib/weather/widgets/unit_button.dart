import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimal_weather/weather/cubit/weather_cubit.dart';
import 'package:minimal_weather/weather/models/weather.dart';

class UnitButton extends StatelessWidget {
  const UnitButton({Key? key, required this.weatherCubit}) : super(key: key);
  final WeatherCubit weatherCubit;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider.value(
      value: weatherCubit,
      child: BlocBuilder<WeatherCubit, WeatherState>(
          buildWhen: (previous, current) =>
              previous.temperatureUnits != current.temperatureUnits,
          builder: (context, state) {
            return TextButton(
              child: Text(
                state.temperatureUnits.isCelsius ? '°C' : '°F',
                style: theme.textTheme.bodyText1,
              ),
              onPressed: () => context.read<WeatherCubit>().toggleUnits(),
            );
          }),
    );
  }
}
