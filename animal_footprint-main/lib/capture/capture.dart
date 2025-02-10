import 'dart:io';
import 'dart:convert';
import 'package:animal/animals/animal_detail.dart';
import 'package:animal/services/auth.dart';
import 'package:animal/services/firestore.dart';
import 'package:animal/services/models.dart'
    as models; // Use the correct import
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    as auth; // Firebase Auth import

// Import your theme file
import 'package:animal/theme.dart'; // Ensure this import matches your theme.dart file path

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Camera & Upload',
      theme: appTheme, // Apply the custom theme here
      home: ModelInferenceScreen(),
    );
  }
}

class ModelInferenceScreen extends StatefulWidget {
  @override
  _ModelInferenceScreenState createState() => _ModelInferenceScreenState();
}

class _ModelInferenceScreenState extends State<ModelInferenceScreen> {
  bool isLoading = false;
  String modelOutput = "";
  File? _image;
  String? _imageUrl;
  Position? _position;
  String? predictedClass = "";
  models.User? currentUser; // Use models.User instead of auth.User

  final picker = ImagePicker();

  // Fetch the current user when the screen loads
  Future<void> _fetchCurrentUser() async {
    try {
      var user = await AuthService().getCurrentUser();
      setState(() {
        currentUser = user; // Set the correct user type
      });
      if (currentUser != null) {
        print(
            'User fetched: ${currentUser!.name}'); // Use name from models.User
      }
    } catch (e) {
      print("Error fetching user: $e");
    }
  }

  // Get the current geolocation
  Future<void> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        modelOutput = 'Location services are disabled.';
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          modelOutput = 'Location permissions are denied.';
        });
        return;
      }
    }

    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // Pick image from the camera
  Future<void> _takePicture() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to generate the TinyPic image URL
  String generateTinyPicImageUrl(String imageName) {
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;
    int day = now.day;

    return 'https://tinypic.host/images/$year/${month.toString().padLeft(2, '0')}/${day.toString().padLeft(2, '0')}/$imageName.md.jpg';
  }

  // Upload image to TinyPic and store the classification history in Firestore
  Future<void> _uploadImageToTinyPic() async {
    if (_image == null) {
      setState(() {
        modelOutput = 'No image selected';
      });
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      // Get geolocation
      await _getLocation();

      // Prepare the image for upload
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://tinypic.host/api/1/upload'))
        ..headers['X-API-Key'] =
            'chv_vyg9_e7c4ec3a2137e38c89818ad0e0f6bfe87779f32e0abed6dfbd0c91811a63c009f20c820a716607d2096b9d3c93f574a8ebf3a4cfe45ac3041211b4ceb37e3c09' // Replace with your TinyPic API key
        ..files.add(await http.MultipartFile.fromPath(
          'source',
          _image!.path,
        ));

      // Send request
      var response = await request.send();
      if (response.statusCode == 200) {
        // Get the response data (image name)
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseBody);
        String imageName = jsonResponse['image']['name'];

        // Generate the image URL based on the response image name
        String imageUrl = generateTinyPicImageUrl(imageName);

        setState(() {
          _imageUrl = imageUrl;
        });

        print("Generated Image URL: $imageUrl");

        // Send the image URL to FastAPI for classification
        await _classifyImage();
      } else {
        setState(() {
          modelOutput = 'Failed to upload image.';
        });
      }
    } catch (e) {
      setState(() {
        modelOutput = 'Error during upload: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Send image URL to FastAPI endpoint for classification
  Future<void> _classifyImage() async {
    if (_imageUrl == null) {
      setState(() {
        modelOutput = 'No image URL available for classification';
      });
      return;
    }

    try {
      var response = await http.post(
        Uri.parse(
            'https://fastapp--cl9snjj.icyflower-c22a5da3.southindia.azurecontainerapps.io/predict'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'image_url': _imageUrl,
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String predictedClassName = data['predicted_class'];

        // Log the predicted class
        print("Predicted Class: $predictedClassName");

        setState(() {
          predictedClass = predictedClassName;
          modelOutput = 'Prediction: $predictedClass';
        });

        // Ensure we have the current user to update classification history
        if (currentUser != null) {
          // Create a new ClassificationHistory object
          models.ClassificationHistory history = models.ClassificationHistory(
            footprintImage: _imageUrl!, // Use the uploaded image URL
            predictedAnimalName: predictedClassName,
            classifiedAt: DateTime.now(),
            classificationAccuracy:
                90, // Hardcoded accuracy, modify if necessary
          );

          // Update the user's classification history in Firestore
          await FirestoreService().updateClassificationHistory(
            history.footprintImage,
            history.predictedAnimalName,
            history.classificationAccuracy,
          );
        }

        // Fetch animal details based on predicted class
        await _fetchAnimalDetails(predictedClassName);
      } else {
        setState(() {
          modelOutput = 'Failed to classify the image.';
        });
      }
    } catch (e) {
      setState(() {
        modelOutput = 'Error during classification: $e';
      });
    }
  }

  // Fetch animal details from Firestore
  Future<void> _fetchAnimalDetails(String predictedClassName) async {
    try {
      // Search for a document in the 'animals' collection where the name matches the predictedClassName
      var animalSnapshot = await FirebaseFirestore.instance
          .collection('animals')
          .doc(predictedClassName)
          .get();

      if (animalSnapshot.exists) {
        var animalData = animalSnapshot.data();
        if (animalData != null) {
          // Map the data from Firestore to the Animal object
          models.Animal animal = models.Animal.fromJson(animalData);

          // Navigate to AnimalDetailScreen with the fetched animal
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AnimalDetailScreen(animal: animal),
            ),
          );
        } else {
          setState(() {
            modelOutput =
                'No data found for the predicted class: $predictedClassName';
          });
        }
      } else {
        setState(() {
          modelOutput =
              'Animal details not found for class: $predictedClassName';
        });
      }
    } catch (e) {
      setState(() {
        modelOutput = 'Error fetching animal details: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser(); // Fetch the current user on screen initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI'),
        backgroundColor: premiumPrimaryColor,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              isLoading
                  ? CircularProgressIndicator()
                  : Text(
                      'Status: $modelOutput',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _takePicture,
                child: Text('Take Picture'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: premiumTextColor,
                  backgroundColor: premiumAccentColor,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 30),
              _image != null
                  ? Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          _image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Text(
                      'No image selected',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _uploadImageToTinyPic,
                child: Text('Upload to TinyPic'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: premiumTextColor,
                  backgroundColor: premiumAccentColor,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
