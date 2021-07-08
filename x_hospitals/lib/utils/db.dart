import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:x_hospitals/models/HUser.dart';
import 'package:x_hospitals/models/PatientRequest.dart';

class XDB {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _uid = FirebaseAuth.instance.currentUser.uid;
  Future<void> setupProfile({
    User user,
    String name,
    String email,
    String location,
    String locationURL,
    double lat,
    double lon,
  }) async {
    try {
      await _firestore.doc("users/$_uid").set({
        "date": DateTime.now(),
        "email": email,
        "isX": false,
        "location": location,
        "locationURL": locationURL,
        "name": name,
        "uid": _uid,
        "lat": lat,
        "lon": lon,
      });
      Fluttertoast.showToast(msg: "Profile setup completed.");
    } catch (err) {
      Fluttertoast.showToast(msg: err.message);
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

  Future<void> changeStatus(bool status, String id) async {
    try {
      if (status) {
        await _firestore.doc("requests/$id").update({
          "status": status,
          "acceptedBy": _uid,
        });
        Fluttertoast.showToast(msg: "Request accepted!");
      } else {
        await _firestore.doc("requests/$id").update({
          "rejectedBy": FieldValue.arrayUnion([_uid]),
        });
        Fluttertoast.showToast(msg: "Request rejected.");
      }
    } catch (err) {
      Fluttertoast.showToast(msg: err.message);
    }
  }
}
