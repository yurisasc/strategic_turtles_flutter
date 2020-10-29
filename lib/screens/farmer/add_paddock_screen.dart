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
      appBar: MyAppBar(user: widget.user, title: 'Add Field'),
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
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          loc == null
                              ? Center(
                                  child: Text('Please enable location service'))
                              : _googleMap(loc),
                          Positioned(
                            top: 16,
                            child: Visibility(
                              visible: _selectedLocation == null,
                              child: Container(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                    'Place a marker in the centre of your field'),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6.0)),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
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

  /// Google map to take expanded width and height.
  /// Once the user location has been provided, move the map camera
  /// to the current location of the user.
  /// On any tap interaction of the map, place a marker there.
  Widget _googleMap(UserLocation loc) {
    return Positioned.fill(
      child: GoogleMap(
        key: _key,
        markers: {},
        initialZoom: 12,
        initialPosition: GeoCoord(loc.latitude, loc.longitude),
        mapType: MapType.hybrid,
        interactive: true,
        onTap: (coordinate) {
          _updateMarker(coordinate);
        },
      ),
    );
  }

  /// Remove the currently placed marker and place a new marker
  /// on where the user last tapped the map.
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

  /// When the "current location" button is pressed, place a marker
  /// on where the user location.
  void _selectCurrentLocation(UserLocation loc) {
    GoogleMap.of(_key).moveCamera(GeoCoord(loc.latitude, loc.longitude));
    _updateMarker(
      GeoCoord(loc.latitude, loc.longitude),
      priority: true,
    );
  }
}
