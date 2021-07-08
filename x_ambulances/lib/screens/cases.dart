import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:x_ambulances/epic.dart';
import 'package:x_ambulances/models/HUser.dart';
import 'package:x_ambulances/models/PatientRequest.dart';
import 'package:x_ambulances/screens/request_view.dart';
import 'package:x_ambulances/services/auth.dart';
import 'package:x_ambulances/services/db.dart';
import 'package:x_ambulances/services/location.dart';

class AcceptedRequests extends StatefulWidget {
  @override
  _AcceptedRequestsState createState() => _AcceptedRequestsState();
}

class _AcceptedRequestsState extends State<AcceptedRequests> {
  bool _aleradyAlerted = false;
  @override
  Widget build(BuildContext context) {
    WisdomRequests reqs = Provider.of<WisdomRequests>(context);
    WisdomHospitals hospitals = Provider.of<WisdomHospitals>(context);
    LocationData locationData = Provider.of<LocationData>(context);
    List<PatientRequest> myReqs = reqs.requests.isNotEmpty
        ? reqs.requests
            .where((element) =>
                (element.author == XAuth().authUser.uid) &&
                !element.isCompleted)
            .toList()
        : [];
    if (myReqs.isEmpty) {
      return ListTile(
        title: Text("No active requests."),
      );
    }
    return ListView.builder(
      itemCount: myReqs.length,
      itemBuilder: (context, ix) {
        PatientRequest req = myReqs[ix];
        HospitalUser hopsitalUser;
        if (req.status && hospitals.hospitals.isNotEmpty) {
          hopsitalUser = hospitals.hospitals
              .singleWhere((element) => element.uid == req.acceptedBy);
          double distance = locationData != null
              ? XLocation().distance(locationData.latitude,
                  locationData.longitude, hopsitalUser.lat, hopsitalUser.lon)
              : 100.0;
          if (distance < 1) {
            if (!_aleradyAlerted) {
              Fluttertoast.showToast(
                  msg: "${hopsitalUser.name} is less than 1km");
              XDB().setUnder1km(req.docId);
              _aleradyAlerted = true;
              Future.delayed(
                  Duration(
                    seconds: 15,
                  ), () {
                XDB().unset1km();
              });
            }
          }
        }

        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return MultiProvider(
                    providers: [
                      StreamProvider<PatientRequest>.value(
                        value: XDB().patientRequestStream(req.docId),
                        initialData: null,
                      ),
                      StreamProvider<WisdomHospitals>.value(
                        value: XDB().wisdomHospitals(),
                        initialData: defaultWisdomHopsitals,
                      ),
                    ],
                    child: RequestViewScreen(),
                  );
                },
              ),
            );
          },
          leading: Icon(Icons.medical_services),
          title: Text("${req.name} - ${req.age}"),
          subtitle: req.status
              ? Text(
                  "Accepted by ${hopsitalUser.name}",
                  style: TextStyle(
                    color: Colors.green,
                  ),
                )
              : Text("Waiting for response"),
          trailing: req.status
              ? IconButton(
                  icon: Icon(
                    Icons.pin_drop,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    launch(hopsitalUser.locationUrl);
                  },
                )
              : Icon(
                  Icons.schedule,
                  color: Colors.orange,
                ),
        );
      },
    );
  }
}
