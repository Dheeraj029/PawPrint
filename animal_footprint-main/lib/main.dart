import 'package:flutter/material.dart';
import 'package:animal/routes.dart';
import 'package:animal/theme.dart';
import 'package:provider/provider.dart';
import 'package:animal/services/services.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(App());
}

/// We are using a StatefulWidget such that we only create the [Future] once,
/// no matter how many times our widget rebuild.
/// If we used a [StatelessWidget], in the event where [App] is rebuilt, that
/// would re-initialize FlutterFire and make our application re-enter loading state,
/// which is undesired.
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const Center(child: Text('Error initializing Firebase'));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          // StreamProvider for ClassificationHistory
          return StreamProvider<List<ClassificationHistory>>(
            create: (_) => FirestoreService().streamClassificationHistory(),
            initialData: [], // Empty list as the default value
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              routes: appRoutes,
              theme: appTheme,
            ),
          );
        }

        // While Firebase is loading, show loading indicator
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
