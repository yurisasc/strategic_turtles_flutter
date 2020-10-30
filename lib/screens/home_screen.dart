import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/screens/broker/broker_home_screen.dart';
import 'package:strategic_turtles/screens/farmer/farmer_home_screen.dart';
import 'package:strategic_turtles/services/provider_firebase_auth.dart';
import 'package:strategic_turtles/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthProvider>(context, listen: false);

    return FutureBuilder<UserModel>(
      future: authService.firestoreUser(authService.getUser),
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (user != null) {
          if (user.role == Constants.Farmer) {
            return FarmerHomeScreen(user: user);
          } else {
            return BrokerHomeScreen(user: user);
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
