// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: implicit_dynamic_parameter
part of 'weather_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherState _$WeatherStateFromJson(Map<String, dynamic> json) {
  return $checkedNew('WeatherState', json, () {
    final val = WeatherState(
      status: $checkedConvert(
          json, 'status', (v) => _$enumDecode(_$WeatherStatusEnumMap, v)),
      temperatureUnits: $checkedConvert(json, 'temperature_units',
          (v) => _$enumDecode(_$TemperatureUnitsEnumMap, v)),
      weatherList: $checkedConvert(
          json,
          'weather_list',
          (v) => (v as List<dynamic>)
              .map((e) => Weather.fromJson(e as Map<String, dynamic>))
              .toList()),
    );
    return val;
  }, fieldKeyMap: const {
    'temperatureUnits': 'temperature_units',
    'weatherList': 'weather_list'
  });
}

Map<String, dynamic> _$WeatherStateToJson(WeatherState instance) =>
    <String, dynamic>{
      'status': _$WeatherStatusEnumMap[instance.status],
      'weather_list': instance.weatherList,
      'temperature_units': _$TemperatureUnitsEnumMap[instance.temperatureUnits],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$WeatherStatusEnumMap = {
  WeatherStatus.initial: 'initial',
  WeatherStatus.loading: 'loading',
  WeatherStatus.success: 'success',
  WeatherStatus.failure: 'failure',
};

const _$TemperatureUnitsEnumMap = {
  TemperatureUnits.fahrenheit: 'fahrenheit',
  TemperatureUnits.celsius: 'celsius',
};
