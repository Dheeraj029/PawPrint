import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class GeoPointConverter
    implements JsonConverter<GeoPoint, Map<String, double>> {
  const GeoPointConverter();

  @override
  GeoPoint fromJson(Map<String, double> json) {
    return GeoPoint(
      json['latitude']!, // Extract the latitude value from the map
      json['longitude']!, // Extract the longitude value from the map
    );
  }

  @override
  Map<String, double> toJson(GeoPoint object) {
    return {
      'latitude': object.latitude,
      'longitude': object.longitude,
    };
  }
}
