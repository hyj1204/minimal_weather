import 'package:json_annotation/json_annotation.dart';


enum LocationType {
  @JsonValue('City')
  city,
  @JsonValue('Region')
  region,
  @JsonValue('State')
  state,
  @JsonValue('Province')
  province,
  @JsonValue('Country')
  country,
  @JsonValue('Continent')
  continent,
  unknown
}

@JsonSerializable()
class Location {
  const Location({
    required this.title,
    required this.locationType,
    required this.latLng,
    required this.woeid,
  });

  final String title;
  final LocationType locationType;
  final LatLng latLng;
  final int woeid;
}

class LatLng {
  const LatLng({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}


