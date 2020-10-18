import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:provider/provider.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/services/services.dart';

import '../widgets/widgets.dart';
import 'widgets/farmer_widgets.dart';

class AddPaddockScreen extends StatefulWidget {
  final Function callback;
  final UserModel user;

  const AddPaddockScreen({
    Key key,
    @required this.callback,
    @required this.user,
  }) : super(key: key);

  @override
  _AddPaddockScreenState createState() => _AddPaddockScreenState();
}

class _AddPaddockScreenState extends State<AddPaddockScreen> {
  final _key = GlobalKey<GoogleMapStateBase>();
  Marker _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(user: widget.user, title: 'Add Paddock'),
      body: Consumer<UserLocation>(
        builder: (context, loc, child) {
          return Row(
            children: [
              Container(
                width: 450,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: PaddockForm(
                        user: widget.user,
                        coordinate: _selectedLocation?.position,
                        callback: widget.callback.call,
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: FloatingActionButton.extended(
                        heroTag: 'back',
                        icon: Icon(Icons.arrow_back),
                        label: Text('Go Back'),
                        onPressed: () {
                          if (widget.callback != null) {
                            widget.callback.call();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    loc == null
                        ? Center(child: Text('Please enable location service'))
                        : _googleMap(loc),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: FloatingActionButton(
                        heroTag: 'current location',
                        child: Icon(Icons.my_location),
                        onPressed: loc == null
                            ? null
                            : () {
                                _selectCurrentLocation(loc);
                              },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _googleMap(UserLocation loc) {
    return Positioned.fill(
      child: GoogleMap(
        key: _key,
        markers: {},
        initialZoom: 12,
        initialPosition: GeoCoord(loc.latitude, loc.longitude),
        mapType: MapType.roadmap,
        interactive: true,
        onTap: (coordinate) {
          _updateMarker(coordinate);
        },
      ),
    );
  }

  void _updateMarker(GeoCoord coordinate, {bool priority = false}) async {
    if (priority) {
      await Future.delayed(Duration(milliseconds: 20));
    }
    setState(() {
      _selectedLocation = Marker(coordinate);
      _key.currentState.clearMarkers();
      _key.currentState.addMarker(_selectedLocation);
    });
  }

  void _selectCurrentLocation(UserLocation loc) {
    GoogleMap.of(_key).moveCamera(GeoCoord(loc.latitude, loc.longitude));
    _updateMarker(
      GeoCoord(loc.latitude, loc.longitude),
      priority: true,
    );
  }
}
