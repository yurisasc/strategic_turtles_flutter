import 'package:flutter/material.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/screens/widgets/app_bar.dart';

import 'widgets/farmer_widgets.dart';

class AddPaddockDetailsScreen extends StatefulWidget {
  final Function callback;
  final UserModel user;
  final Marker coordinate;

  const AddPaddockDetailsScreen({
    Key key,
    @required this.callback,
    @required this.user,
    @required this.coordinate,
  }) : super(key: key);

  @override
  _AddPaddockDetailsScreenState createState() =>
      _AddPaddockDetailsScreenState();
}

class _AddPaddockDetailsScreenState extends State<AddPaddockDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF585858),
      appBar: MyAppBar(
        user: widget.user,
        title: 'Insert Paddock Details',
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 400,
              child: PaddockForm(
                user: widget.user,
                coordinate: widget.coordinate.position,
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: FloatingActionButton.extended(
              heroTag: 'back',
              icon: Icon(Icons.arrow_back),
              label: Text('Reselect Location '),
              onPressed: () {
                if (widget.callback != null) {
                  widget.callback.call();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
