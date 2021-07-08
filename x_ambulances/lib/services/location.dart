import 'package:location/location.dart';
import 'dart:math' as Math;

class XLocation {
  Location location = new Location();

  Stream<LocationData> getLocation() {
    return location.onLocationChanged;
  }

  double distance(double x1, double y1, double x2, double y2) {
    var R = 6371; // km
    var dLat = toRad(x2 - x1);
    var dLon = toRad(y2 - y1);
    var lat1 = toRad(x1);
    var lat2 = toRad(x2);

    var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.sin(dLon / 2) *
            Math.sin(dLon / 2) *
            Math.cos(lat1) *
            Math.cos(lat2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    var d = R * c;
    return d;
  }

  // Converts numeric degrees to radians
  double toRad(double val) {
    return val * Math.pi / 180;
  }
}
