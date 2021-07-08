import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:x_hospitals/models/Coordinates.dart';

class XLocation {
  Location location = new Location();

  Future<Coordinates> getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        Fluttertoast.showToast(
            msg: "Service is disabled. Can't fetch location.");
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        Fluttertoast.showToast(msg: "Location permission is denied.");
        return null;
      }
    }

    _locationData = await location.getLocation();
    return Coordinates(
      lat: _locationData.latitude,
      lon: _locationData.longitude,
    );
  }
}
