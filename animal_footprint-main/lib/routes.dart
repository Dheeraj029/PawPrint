import 'package:animal/capture/capture.dart';
import 'package:animal/profile/profile.dart';
import 'package:animal/login/login.dart';
import 'package:animal/home/home.dart';

var appRoutes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/capture': (context) => MyApp(),
  '/profile': (context) => const ProfileScreen(),
};
