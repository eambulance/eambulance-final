import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_hospitals/models/HUser.dart';
import 'package:x_hospitals/models/PatientRequest.dart';
import 'package:x_hospitals/screens/request_view.dart';
import 'package:x_hospitals/utils/db.dart';

import '../epic.dart';

class ActiveRequests extends StatefulWidget {
  @override
  _ActiveRequestsState createState() => _ActiveRequestsState();
}

class _ActiveRequestsState extends State<ActiveRequests> {
  @override
  Widget build(BuildContext context) {
    WisdomRequests reqs = Provider.of<WisdomRequests>(context);
    WisdomHospitals hospitals = Provider.of<WisdomHospitals>(context);
    print(reqs.requests.length);
    List<PatientRequest> myReqs = reqs.requests.isNotEmpty
        ? reqs.requests.where((element) => !element.isCompleted).toList()
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
            print(req.docId);
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
                    //launch(hopsitalUser.locationUrl);
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
