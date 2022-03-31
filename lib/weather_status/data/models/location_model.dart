// ignore_for_file: always_use_package_imports

import '../../domain/entities/location_entity.dart';

class LocationModel extends Location {
  LocationModel(
      {required String title,
      required LocationType locationType,
      required LatLng latLng,
      required int woeid})
      : super(
            title: title,
            locationType: locationType,
            latLng: latLng,
            woeid: woeid);

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      title: json['title'] as String,
      locationType: json['locationType'] as LocationType,
      latLng: json['latLng'] as LatLng,
      woeid: json['woeid'] as int,
    );
  }
}
