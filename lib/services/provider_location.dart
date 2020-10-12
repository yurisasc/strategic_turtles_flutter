import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class UserLocation {
  final double latitude;
  final double longitude;

  UserLocation({@required this.latitude, @required this.longitude});
  LatLng toLatLng() => LatLng(this.latitude, this.longitude);
}

class LocationProvider {
  UserLocation _currentlocation;
  StreamController<UserLocation> _locationController =
  StreamController<UserLocation>();
  Stream<UserLocation> get locationStream => _locationController.stream;
  var location = Location();

  LocationProvider() {
    // Request permission to use location
    location.requestPermission().then((granted) => {
      // If granted, listen to the onLocationChanged stream
      location.onLocationChanged.listen((locationData) {
        if (locationData != null) {
          print(
              'Lat: ${locationData.latitude}, Lng: ${locationData.longitude}');
          _locationController.add(UserLocation(
            latitude: locationData.latitude,
            longitude: locationData.longitude,
          ));
        }
      })
    });
  }

  Future<UserLocation> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentlocation = UserLocation(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
      );
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }

    return _currentlocation;
  }
}
