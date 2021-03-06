import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

enum WeatherCondition {
  clear,
  rainy,
  cloudy,
  snowy,
  thundery,
  unknown,
}

@JsonSerializable()
class Weather extends Equatable {
  const Weather({
    required this.location,
    required this.temperature,
    required this.condition,
    required this.date,
  });

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherToJson(this);

  final String location;
  final double temperature;
  @JsonKey(unknownEnumValue: WeatherCondition.unknown)
  final WeatherCondition condition;
  final DateTime date;

  @override
  List<Object> get props => [location, temperature, condition, date];
}
