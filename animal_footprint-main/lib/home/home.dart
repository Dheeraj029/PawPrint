import 'package:animal/animals/animals.dart';
import 'package:animal/capture/capture.dart';
import 'package:animal/login/login.dart';
import 'package:animal/services/auth.dart';
import 'package:animal/shared/bottom_nav.dart';
import 'package:animal/shared/error.dart';
import 'package:animal/shared/loading.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return const Center(
            child: ErrorMessage(),
          );
        } else if (snapshot.hasData) {
          return const AnimalsScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
