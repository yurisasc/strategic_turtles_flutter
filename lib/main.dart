import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:provider/provider.dart';
import 'package:strategic_turtles/screens/screens.dart';
import 'package:strategic_turtles/services/provider_paddock.dart';
import 'package:strategic_turtles/services/provider_requests.dart';
import 'package:strategic_turtles/services/services.dart';

void main() {
  GoogleMap.init('AIzaSyCgmZ96WosTrWpuClxwIAnlQmM7t5nJVZg');
  runApp(MultiProvider(
    providers: [
      StreamProvider<UserLocation>(
        create: (context) => LocationProvider().locationStream,
      ),
      ChangeNotifierProvider<AuthProvider>(
        create: (context) => AuthProvider(),
      ),
      ChangeNotifierProvider<PaddockProvider>(
        create: (context) => PaddockProvider(),
      ),
      ChangeNotifierProvider<RequestsProvider>(
        create: (context) => RequestsProvider(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthProvider>(context);

    return StreamBuilder<auth.User>(
        stream: authService.user,
        builder: (context, stream) {
          if (stream.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (stream.hasError) {
            return Center(child: Text(stream.error.toString()));
          }

          final user = stream.data;
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.lightGreen,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              accentColor: const Color(0xFF7D8F39),
              textSelectionColor: Colors.white,
            ),
            home: user == null ? LoginScreen() : HomeScreen(),
          );
        });
  }
}
