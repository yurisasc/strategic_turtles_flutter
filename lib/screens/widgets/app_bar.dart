import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/services/services.dart';

import 'widgets.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserModel user;
  final String title;

  const MyAppBar({
    Key key,
    @required this.user,
    @required this.title,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthProvider>(context, listen: false);

    return AppBar(
      title: SizedBox(
        width: 250,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).textSelectionColor,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).accentColor,
      actions: [
        ProfileNavigation(user: user),
        IconButton(
          icon: Icon(
            Icons.exit_to_app,
            color: Colors.white,
          ),
          onPressed: authService.signOut,
        )
      ],
    );
  }
}
