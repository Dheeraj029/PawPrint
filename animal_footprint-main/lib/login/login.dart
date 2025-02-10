import 'package:animal/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animal/theme.dart'; // Make sure to import your theme

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          appTheme.scaffoldBackgroundColor, // Using theme background color
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/ic_lau.png',
              width: 250, // Adjust the width as needed
              height: 250, // Adjust the height as needed
              fit: BoxFit.fitHeight, // Adjust the fit if needed
            ),
            const SizedBox(height: 40), // Space between image and buttons

            // Google login button
            LoginButton(
              text: 'Sign in with Google',
              icon: FontAwesomeIcons.google,
              color: appTheme.primaryColor, // Using theme primary color
              loginMethod: AuthService().googleLogin,
            ),
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function loginMethod;

  const LoginButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.loginMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          color: Colors.white,
          size: 22,
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(20),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12), // Rounded corners for a modern look
          ),
        ),
        onPressed: () async {
          await loginMethod();
          // Navigate to the home screen or profile after login
          Navigator.pushReplacementNamed(context, '/home');
        },
        label: Text(
          text,
          style: appTheme.textTheme.bodyLarge!.copyWith(
            color: Colors.white, // Text color for better contrast
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
