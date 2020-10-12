import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:provider/provider.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/screens/broker/services/provider_selected_paddock.dart';
import 'package:strategic_turtles/screens/broker/widgets/broker_widgets.dart';
import 'package:strategic_turtles/screens/widgets/app_bar.dart';
import 'package:strategic_turtles/services/provider_location.dart';
import 'package:strategic_turtles/services/services.dart';

class BrowsePaddockScreen extends StatefulWidget {
  final UserModel user;
  final Function callback;

  const BrowsePaddockScreen({Key key, this.user, this.callback})
      : super(key: key);

  @override
  _BrowsePaddockScreenState createState() => _BrowsePaddockScreenState();
}

class _BrowsePaddockScreenState extends State<BrowsePaddockScreen> {
  final _key = GlobalKey<GoogleMapStateBase>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(user: widget.user, title: 'Browse Paddock'),
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
                      child: PaddockInfo(
                        user: widget.user,
                        callback: widget.callback,
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
                  children: [
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
    final paddockService = Provider.of<PaddockProvider>(context);
    final selectedPaddockService =
        Provider.of<SelectedPaddock>(context, listen: false);
    final stream = paddockService.getAllPaddocks().map((event) => event
        .map((e) => Marker(
              GeoCoord(e.latitude, e.longitude),
              onTap: (value) {
                selectedPaddockService.selectPaddock(e);
              },
            ))
        .toSet());
    return StreamBuilder<Set<Marker>>(
      stream: stream,
      builder: (context, stream) {
        if (stream.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (stream.hasError) {
          return Center(child: Text(stream.error.toString()));
        }

        final markers = stream.data;
        return GoogleMap(
          key: _key,
          markers: markers,
          initialPosition: GeoCoord(loc.latitude, loc.longitude),
          mapType: MapType.roadmap,
        );
      },
    );
  }

  void _selectCurrentLocation(UserLocation loc) {
    GoogleMap.of(_key).moveCamera(GeoCoord(loc.latitude, loc.longitude));
  }
}
