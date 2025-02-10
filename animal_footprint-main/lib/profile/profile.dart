import 'package:animal/services/auth.dart';
import 'package:animal/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animal/services/models.dart';
import 'package:animal/theme.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? currentUser; // The current user
  bool isLoading = true; // Flag to show loading indicator

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  // Fetch user profile data from AuthService and FirestoreService
  Future<void> _fetchUserProfile() async {
    try {
      // Fetch the current user from AuthService
      var user = await AuthService().getCurrentUser();

      if (user != null) {
        setState(() {
          currentUser = user;
        });
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle errors (could display an error message or retry logic)
      print("Error fetching user profile: $e");
    }
  }

  // Helper function to handle converting Timestamp to DateTime
  String formatDateTime(DateTime dateTime) {
    return DateFormat('MMMM dd, yyyy, h:mm a')
        .format(dateTime); // e.g., 'December 24, 2024, 9:09 PM'
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: premiumPrimaryColor,
        elevation: 0, // Removes the shadow to create a clean look
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : currentUser == null
              ? const Center(child: Text('User not found'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Picture Section
                      Center(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                            currentUser!.profilePicture ??
                                'https://example.com/default_profile_picture.png',
                          ),
                          backgroundColor: Colors.transparent,
                          child: currentUser!.profilePicture == null
                              ? Icon(
                                  Icons.person,
                                  size: 50,
                                  color: premiumTextColor,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // User Name and Email
                      Text(
                        currentUser!.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: premiumTextColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentUser!.email,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: premiumSecondaryTextColor),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Classification History',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: premiumTextColor),
                      ),
                      const SizedBox(height: 16),
                      // StreamBuilder to listen to classification history
                      StreamBuilder<List<ClassificationHistory>>(
                        stream:
                            FirestoreService().streamClassificationHistory(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Text(
                              'No classifications yet.',
                              style: TextStyle(
                                color: premiumSecondaryTextColor,
                                fontStyle: FontStyle.italic,
                              ),
                            );
                          } else {
                            var historyList = snapshot.data!;
                            return Expanded(
                              child: ListView.builder(
                                itemCount: historyList.length,
                                itemBuilder: (context, index) {
                                  ClassificationHistory history =
                                      historyList[index];

                                  return Card(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 4,
                                    color:
                                        premiumCardColor, // Card color using premiumCardColor
                                    child: ListTile(
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          history.footprintImage,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      title: Text(
                                        history.predictedAnimalName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  premiumTextColor, // Title text color
                                            ),
                                      ),
                                      subtitle: Text(
                                        'Date: ${formatDateTime(history.classifiedAt)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                                color:
                                                    premiumSecondaryTextColor), // Subtitle text color
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 32),
                      // Sign Out Button
                      ElevatedButton(
                        onPressed: () async {
                          await AuthService().signOut();
                          Navigator.of(context)
                              .pushNamedAndRemoveUntil('/', (route) => false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              premiumAccentColor, // Gold accent for the button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
