import 'package:animal/services/geo_point_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate(); // Convert Firestore Timestamp to DateTime
  }

  @override
  Timestamp toJson(DateTime dateTime) {
    return Timestamp.fromDate(
        dateTime); // Convert DateTime back to Firestore Timestamp
  }
}

// Animal model - Represents an animal with its characteristics
@JsonSerializable()
class Animal {
  String id;
  String name;
  String description;
  String imageUrl;
  String habitat;
  String distinctive_traits;
  String height;
  String lifespan;
  String weight;
  String footImage;
  String running_speed;
  String scientific_name;
  String diet;

  Animal({
    this.id = '',
    this.name = '',
    this.description = '',
    this.imageUrl = '',
    this.habitat = '',
    this.distinctive_traits = '',
    this.height = '',
    this.lifespan = '',
    this.weight = '',
    this.running_speed = '',
    this.scientific_name = '',
    this.footImage = '',
    this.diet = '', // Make it required in the constructor
  });

  factory Animal.fromJson(Map<String, dynamic> json) => _$AnimalFromJson(json);
  Map<String, dynamic> toJson() => _$AnimalToJson(this);
}

// User model - Represents a user and their preferences/history
@JsonSerializable()
class User {
  String uid; // User ID (from Firebase Authentication)
  String email; // Email address
  String name; // User's full name
  String? profilePicture; // Optional profile picture URL
  @TimestampConverter()
  DateTime createdAt; // Account creation timestamp
  @TimestampConverter()
  DateTime updatedAt; // Last profile update timestamp
  Map<String, dynamic>
      preferences; // User preferences (e.g., language, notifications)
  @GeoPointConverter() // Use custom converter for GeoPoint
  GeoPoint? geoTag; // User's last known location (latitude, longitude)
  List<ClassificationHistory> history; // List of classification history entries

  User({
    this.uid = '',
    this.email = '',
    this.name = '',
    this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
    this.preferences = const {},
    this.geoTag,
    this.history = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

// ClassificationHistory model - Stores each classification made by the user
@JsonSerializable()
class ClassificationHistory {
  String footprintImage; // URL of the footprint image
  String
      predictedAnimalName; // The name of the predicted animal from the AI model
  DateTime classifiedAt; // Timestamp of when the classification was made
  //@GeoPointConverter()
  //GeoPoint geoTag; // Location of the user when the classification was made
  double classificationAccuracy; // Confidence score of the AI model
  String? notes; // Optional notes added by the user

  ClassificationHistory({
    this.footprintImage = '',
    this.predictedAnimalName = '',
    required this.classifiedAt,
    //required this.geoTag,
    this.classificationAccuracy = 0.0,
    this.notes,
  });

  factory ClassificationHistory.fromJson(Map<String, dynamic> json) =>
      _$ClassificationHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$ClassificationHistoryToJson(this);
}
