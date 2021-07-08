import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:x_ambulances/models/HUser.dart';
import 'package:x_ambulances/models/PatientRequest.dart';
import 'package:x_ambulances/services/auth.dart';

class XDB {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseDatabase _database = FirebaseDatabase.instance;
  String _uid = XAuth().authUser.uid;

  Future<bool> setupProfile(
      {String name, String email, String phone, String vhNo}) async {
    try {
      _firestore.doc("users/$_uid").set({
        "name": name,
        "uid": _uid,
        "email": email,
        "phone": phone,
        "vhNo": vhNo,
        "isX": true,
        "date": DateTime.now(),
      });
      Fluttertoast.showToast(msg: "Profile setup completed.");
      return true;
    } catch (err) {
      Fluttertoast.showToast(msg: "Error: ${err.message}");
      return false;
    }
  }

  Stream<WisdomHospitals> wisdomHospitals() {
    return _firestore
        .collection("users")
        .where("isX", isEqualTo: false)
        .snapshots()
        .map(
          (event) => WisdomHospitals(
            status: true,
            hospitals: event.docs
                .map(
                  (e) => HospitalUser.fromMap(e.data()),
                )
                .toList(),
          ),
        );
  }

  Future<bool> sendRequest(
      {String name,
      int age,
      int gender,
      int bloodReq,
      int bloodGroup,
      int ventilatorReq}) async {
    try {
      await _firestore.collection("requests").add({
        "name": name,
        "age": age,
        "gender": gender,
        "bloodReq": bloodReq,
        "bloodGroup": bloodGroup,
        "ventReq": ventilatorReq,
        "status": false,
        "rejectedBy": [],
        "dateTime": DateTime.now(),
        "author": _uid,
        "isCompleted": false,
        "acceptedBy": "",
        "isUnderOneKilometer": false,
      });
      Fluttertoast.showToast(msg: "Request successfully sent.");
      return true;
    } catch (err) {
      Fluttertoast.showToast(msg: err.message);
      return false;
    }
  }

  Stream<WisdomRequests> wisdomRequests() {
    return _firestore
        .collection("requests")
        .orderBy("dateTime", descending: true)
        .snapshots()
        .map(
          (event) => WisdomRequests(
            status: true,
            requests: event.docs
                .map(
                  (e) => PatientRequest.fromMap(e.data(), e.id),
                )
                .toList(),
          ),
        );
  }

  Stream<PatientRequest> patientRequestStream(String id) {
    return _firestore.doc("requests/$id").snapshots().map(
      (event) {
        if (event.data() == null) {
          print("OHHH IDDDDD: $id");
          print("THIS SHIT IS NULL");
        }
        return PatientRequest.fromMap(
          event.data(),
          event.id,
        );
      },
    );
  }

  Future<void> closeCase(String id) async {
    try {
      _firestore.doc("requests/$id").update({
        "isCompleted": true,
      });
      Fluttertoast.showToast(msg: "Success!");
    } catch (err) {
      Fluttertoast.showToast(msg: "Error while closing case.");
    }
  }

  Future<void> setUnder1km(String id) async {
    try {
      _firestore.doc("requests/$id").update({
        "isUnderOneKilometer": true,
      });
      await _database.reference().child("requests").set({"status": "Accepted"});
    } catch (err) {
      print("A minor bug happened... ignoring :)");
    }
  }

  Future<void> unset1km() async {
    try {
      await _database.reference().child("requests").set({"status": "Rejected"});
      Fluttertoast.showToast(msg: "Signals are back into normal.");
    } catch (err) {
      print("A minor bug happened... ignoring :)");
    }
  }
}
