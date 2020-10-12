import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/screens/broker/browse_paddock_screen.dart';
import 'package:strategic_turtles/screens/widgets/navigation_drawer/collapsing_navigation_drawer.dart';
import 'package:strategic_turtles/screens/widgets/paddock_list.dart';
import 'package:strategic_turtles/screens/widgets/paddock_request/request_list.dart';
import 'package:strategic_turtles/screens/widgets/widgets.dart';

import 'services/provider_selected_paddock.dart';

class BrokerHomeScreen extends StatefulWidget {
  final UserModel user;

  const BrokerHomeScreen({Key key, this.user}) : super(key: key);

  @override
  _BrokerHomeScreenState createState() => _BrokerHomeScreenState();
}

class _BrokerHomeScreenState extends State<BrokerHomeScreen> {
  bool _isBrowsingPaddock = false;
  bool _isViewingPaddockList = true;
  bool _isViewingRequestList = false;

  @override
  Widget build(BuildContext context) {
    return _isBrowsingPaddock
        ? ChangeNotifierProvider(
            create: (_) => SelectedPaddock(),
            child: BrowsePaddockScreen(user: widget.user, callback: _back))
        : Scaffold(
            backgroundColor: const Color(0xFF585858),
            appBar: MyAppBar(user: widget.user, title: 'Broker Homepage'),
            body: Row(
              children: [
                CollapsingNavigationDrawer(
                  navigationItems: [
                    NavigationModel(
                      title: 'Paddock List',
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
                        isSender: true,
                      ))
                    : SizedBox.shrink(),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                _browsePaddock();
              },
              label: Text('Add Paddock '),
              icon: Icon(Icons.add),
            ),
          );
  }

  void _browsePaddock() {
    setState(() {
      _isBrowsingPaddock = true;
    });
  }

  void _back() {
    setState(() {
      _isBrowsingPaddock = false;
    });
  }
}
