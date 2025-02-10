// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Animal _$AnimalFromJson(Map<String, dynamic> json) => Animal(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      habitat: json['habitat'] as String? ?? '',
      distinctive_traits: json['distinctive_traits'] as String? ?? '',
      height: json['height'] as String? ?? '',
      lifespan: json['lifespan'] as String? ?? '',
      weight: json['weight'] as String? ?? '',
      running_speed: json['running_speed'] as String? ?? '',
      scientific_name: json['scientific_name'] as String? ?? '',
      footImage: json['footImage'] as String? ?? '',
      diet: json['diet'] as String? ?? '',
    );

Map<String, dynamic> _$AnimalToJson(Animal instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'habitat': instance.habitat,
      'distinctive_traits': instance.distinctive_traits,
      'height': instance.height,
      'lifespan': instance.lifespan,
      'weight': instance.weight,
      'footImage': instance.footImage,
      'running_speed': instance.running_speed,
      'scientific_name': instance.scientific_name,
      'diet': instance.diet,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      uid: json['uid'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      profilePicture: json['profilePicture'] as String?,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp),
      preferences: json['preferences'] as Map<String, dynamic>? ?? const {},
      // geoTag: _$JsonConverterFromJson<Map<String, double>, GeoPoint>(
      //     json['geoTag'], const GeoPointConverter().fromJson),
      history: (json['history'] as List<dynamic>?)
              ?.map((e) =>
                  ClassificationHistory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'name': instance.name,
      'profilePicture': instance.profilePicture,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
      'preferences': instance.preferences,
      //   'geoTag': _$JsonConverterToJson<Map<String, double>, GeoPoint>(
      //       instance.geoTag, const GeoPointConverter().toJson),
      'history': instance.history,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

ClassificationHistory _$ClassificationHistoryFromJson(
        Map<String, dynamic> json) =>
    ClassificationHistory(
      footprintImage: json['footprintImage'] as String? ?? '',
      predictedAnimalName: json['predictedAnimalName'] as String? ?? '',
      classifiedAt: DateTime.parse(json['classifiedAt'] as String),
      // geoTag: const GeoPointConverter()
      //    .fromJson(json['geoTag'] as Map<String, double>),
      classificationAccuracy:
          (json['classificationAccuracy'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$ClassificationHistoryToJson(
        ClassificationHistory instance) =>
    <String, dynamic>{
      'footprintImage': instance.footprintImage,
      'predictedAnimalName': instance.predictedAnimalName,
      'classifiedAt': instance.classifiedAt.toIso8601String(),
      //'geoTag': const GeoPointConverter().toJson(instance.geoTag),
      'classificationAccuracy': instance.classificationAccuracy,
      'notes': instance.notes,
    };
