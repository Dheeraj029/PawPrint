import 'package:animal/services/models.dart' as models;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

// Stream to listen for authentication state changes
  Stream<firebase_auth.User?> get userStream {
    return _auth.authStateChanges();
  }

  // Sign in anonymously
  Future<void> anonLogin() async {
    try {
      firebase_auth.UserCredential userCredential =
          await _auth.signInAnonymously();
      firebase_auth.User? user = userCredential.user;

      if (user != null) {
        // Create a new User model from models.dart
        models.User newUser = models.User(
          uid: user.uid,
          email: user.email ?? 'guest@example.com',
          name: 'Guest', // Default name for guest users
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          history: [], // Empty history for now
        );

        // Save user data to Firestore
        await _saveUserToFirestore(newUser);
      }
    } catch (e) {
      print('Error signing in anonymously: $e');
    }
  }

  // Sign in with Google
  Future<void> googleLogin() async {
    try {
      // Step 1: Trigger the Google Sign-In process
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the login
        return;
      }

      // Step 2: Get the authentication details
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Step 3: Create the Google credentials
      firebase_auth.AuthCredential credential =
          firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Step 4: Sign in with the credential
      firebase_auth.UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      firebase_auth.User? user = userCredential.user;

      if (user != null) {
        // Create a new User model with the Google user's details
        models.User newUser = models.User(
          uid: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? 'Anonymous',
          profilePicture: user.photoURL,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          history: [],
        );

        // Save user data to Firestore
        await _saveUserToFirestore(newUser);
      }
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }

  // Save user details to Firestore
  Future<void> _saveUserToFirestore(models.User user) async {
    try {
      // Save the user data into Firestore under the 'users' collection
      await _db.collection('users').doc(user.uid).set(user.toJson());
    } catch (e) {
      print('Error saving user to Firestore: $e');
    }
  }

  // Sign out the user
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut(); // Sign out from Google as well
  }

  // Check if the user is signed in
  Future<models.User?> getCurrentUser() async {
    firebase_auth.User? user = _auth.currentUser;
    if (user != null) {
      // Retrieve user details from Firestore if available
      DocumentSnapshot userDoc =
          await _db.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        return models.User.fromJson(userDoc.data() as Map<String, dynamic>);
      }
    }
    return null;
  }
}
