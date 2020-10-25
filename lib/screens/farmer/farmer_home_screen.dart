import 'package:flutter/material.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/screens/screens.dart';
import 'package:strategic_turtles/screens/widgets/navigation_drawer/collapsing_navigation_drawer.dart';
import 'package:strategic_turtles/screens/widgets/paddock_request/request_list.dart';

import '../widgets/widgets.dart';

class FarmerHomeScreen extends StatefulWidget {
  final UserModel user;

  const FarmerHomeScreen({Key key, this.user}) : super(key: key);

  @override
  _FarmerHomeScreenState createState() => _FarmerHomeScreenState();
}

class _FarmerHomeScreenState extends State<FarmerHomeScreen> {
  bool _isCreatePaddock = false;
  bool _isViewingPaddockList = true;
  bool _isViewingRequestList = false;

  @override
  Widget build(BuildContext context) {
    return _isCreatePaddock
        ? AddPaddockScreen(user: widget.user, callback: _back)
        : Scaffold(
            backgroundColor: const Color(0xFF585858),
            appBar: MyAppBar(user: widget.user, title: 'Farmer Homepage'),
            body: Row(
              children: [
                CollapsingNavigationDrawer(
                  navigationItems: [
                    NavigationModel(
                      title: 'Field List',
                      icon: Icons.list,
                      onTap: () {
                        setState(() {
                          _isViewingPaddockList = true;
                          _isViewingRequestList = false;
                        });
                      },
                    ),
                    NavigationModel(
                      title: 'Requests',
                      icon: Icons.notifications,
                      onTap: () {
                        setState(() {
                          _isViewingPaddockList = false;
                          _isViewingRequestList = true;
                        });
                      },
                    ),
                  ],
                ),
                _isViewingPaddockList
                    ? Expanded(child: PaddockList(user: widget.user))
                    : SizedBox.shrink(),
                _isViewingRequestList
                    ? Expanded(
                        child: RequestList(
                        user: widget.user,
                        isSender: false,
                      ))
                    : SizedBox.shrink(),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                _createPaddock();
              },
              label: Text('Add field '),
              icon: Icon(Icons.add),
            ),
          );
  }

  void _createPaddock() {
    setState(() {
      _isCreatePaddock = true;
    });
  }

  void _back() {
    setState(() {
      _isCreatePaddock = false;
    });
  }
}
