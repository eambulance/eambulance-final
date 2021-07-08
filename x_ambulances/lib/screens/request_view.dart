import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:x_ambulances/epic.dart';
import 'package:x_ambulances/models/Details.dart';
import 'package:x_ambulances/models/HUser.dart';
import 'package:x_ambulances/models/PatientRequest.dart';
import 'package:x_ambulances/services/db.dart';

class RequestViewScreen extends StatefulWidget {
  @override
  _RequestViewScreenState createState() => _RequestViewScreenState();
}

class _RequestViewScreenState extends State<RequestViewScreen> {
  @override
  Widget build(BuildContext context) {
    PatientRequest patientRequest = Provider.of<PatientRequest>(context);
    WisdomHospitals wisdomHospitals = Provider.of<WisdomHospitals>(context);

    Details details;
    if (patientRequest != null) {
      String name = patientRequest.name;
      String gender;
      switch (patientRequest.gender) {
        case 0:
          gender = "Male";
          break;
        case 1:
          gender = "Female";
          break;
        case 2:
          gender = "LGBTQ+";
          break;
        default:
          print("ERR");
      }
      int age = patientRequest.age;
      bool bloodReq = patientRequest.bloodReq == 0;
      String bloodGroup = bloodGroups[patientRequest.bloodGroup].name;
      String ventReq;
      switch (patientRequest.ventReq) {
        case 0:
          ventReq = "Yes";
          break;
        case 1:
          ventReq = "No";
          break;
        case 2:
          ventReq = "May be";
          break;
        default:
          print("Err");
      }
      details = Details(
        age: age,
        name: name,
        gender: gender,
        bloodGroup: bloodGroup,
        bloodReq: bloodReq,
        ventReq: ventReq,
      );
    }
    HospitalUser hopsitalUser;
    if (patientRequest != null &&
        patientRequest.status &&
        wisdomHospitals.hospitals.isNotEmpty) {
      hopsitalUser = wisdomHospitals.hospitals
          .singleWhere((element) => element.uid == patientRequest.acceptedBy);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Details"),
      ),
      body: patientRequest == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                ListTile(
                  trailing: patientRequest.status
                      ? Icon(
                          Icons.done,
                          color: Colors.green,
                        )
                      : Icon(
                          Icons.schedule,
                          color: Colors.orange,
                        ),
                  leading: Icon(
                    Icons.military_tech,
                    color: patientRequest.status ? Colors.green : Colors.orange,
                  ),
                  subtitle: Text("Status"),
                  title: !patientRequest.isCompleted
                      ? patientRequest.status
                          ? Text(
                              "Accepted",
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            )
                          : Text(
                              "Waiting for response",
                              style: TextStyle(
                                color: Colors.orange,
                              ),
                            )
                      : Text(
                          "Closed",
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(details.name),
                  subtitle: Text("Name"),
                ),
                ListTile(
                  leading: Icon(Icons.today),
                  title: Text("${details.age}"),
                  subtitle: Text("Age"),
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text(DateFormat("dd-MM-yyyy kk:hh")
                      .format(patientRequest.dateTime)),
                  subtitle: Text("Reported Date"),
                ),
                ListTile(
                  leading: Icon(Icons.face),
                  title: Text("${details.gender}"),
                  subtitle: Text("Gender"),
                ),
                ListTile(
                  leading: Icon(Icons.invert_colors),
                  title: Text(
                    "${details.bloodReq ? 'Yes' : 'No'}",
                  ),
                  subtitle: Text("Blood Required"),
                ),
                ListTile(
                  leading: Icon(Icons.invert_colors),
                  title: Text("${details.bloodGroup}"),
                  subtitle: Text("Blood Group"),
                ),
                ListTile(
                  leading: Icon(Icons.healing),
                  title: Text("${details.ventReq}"),
                  subtitle: Text("Ventilator Required"),
                ),
                if (patientRequest.status) ...[
                  ListTile(
                    title: Text(
                      "Accepted by",
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(hopsitalUser.name),
                    leading: Icon(Icons.local_hospital),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.pin_drop,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        launch(hopsitalUser.locationUrl);
                      },
                    ),
                  )
                ],
                if (patientRequest.rejectedBy.isNotEmpty) ...[
                  ListTile(
                    title: Text(
                      "Rejected by",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  )
                ]
              ]..addAll(patientRequest.rejectedBy.map((element) {
                  HospitalUser _hU = wisdomHospitals.hospitals.isNotEmpty
                      ? wisdomHospitals.hospitals
                          .singleWhere((el) => element == el.uid)
                      : defaultHospitalUser;
                  return ListTile(
                    title: Text(_hU.name),
                    leading: Icon(Icons.local_hospital),
                  );
                })),
            ),
      floatingActionButton:
          patientRequest != null && !patientRequest.isCompleted
              ? FloatingActionButton.extended(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  onPressed: () {
                    XDB().closeCase(patientRequest.docId);
                  },
                  label: Text("Close Case"),
                  icon: Icon(Icons.cancel),
                )
              : FloatingActionButton.extended(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  onPressed: () {
                    Fluttertoast.showToast(msg: "Already closed.");
                  },
                  label: Text("Closed"),
                  icon: Icon(Icons.done),
                ),
    );
  }
}
