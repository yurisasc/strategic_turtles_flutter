import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/screens/profile_screen.dart';
import 'package:strategic_turtles/utils/constants.dart';

class ProfileNavigation extends StatelessWidget {
  const ProfileNavigation({
    Key key,
    @required this.user,
  }) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              userId: user.uid,
              role: user.role,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.grey[200],
              child: ClipOval(
                child: user.photoUrl != ""
                    ? CachedNetworkImage(
                        imageUrl: user.photoUrl, fit: BoxFit.contain)
                    : Image.asset('assets/img/user_default.png',
                        fit: BoxFit.contain),
              ),
            ),
            SizedBox(width: 8.0),
            Text(
              user.role == Constants.Broker
                  ? '${user.firstName} ${user.lastName}'
                  : '${user.farmName}',
              style: TextStyle(color: Theme.of(context).textSelectionColor),
            ),
          ],
        ),
      ),
    );
  }
}
