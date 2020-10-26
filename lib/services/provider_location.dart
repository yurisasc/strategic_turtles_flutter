import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

/// A model class of the user location
class UserLocation {
  final double latitude;
  final double longitude;

  UserLocation({@required this.latitude, @required this.longitude});
  LatLng toLatLng() => LatLng(this.latitude, this.longitude);
}

/// Service to keep track of the user location.
/// This will only be used when the user wants to open a map
/// which will set the user location as the initial position
class LocationProvider {
  UserLocation _currentlocation;
  StreamController<UserLocation> _locationController =
  StreamController<UserLocation>();
  Stream<UserLocation> get locationStream => _locationController.stream;
  var location = Location();

  /// Initialize a stream that can be listened by widgets
  /// to provide user location. Will request the user permission beforehand.
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

  /// Get the user location
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
