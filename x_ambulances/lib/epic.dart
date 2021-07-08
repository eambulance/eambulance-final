import 'package:x_ambulances/models/HUser.dart';
import 'package:x_ambulances/models/PatientRequest.dart';

import 'models/BloodGroup.dart';

WisdomHospitals defaultWisdomHopsitals = WisdomHospitals(
  status: false,
  hospitals: [],
);

HospitalUser defaultHospitalUser = HospitalUser(
  uid: "",
  name: "",
  location: "",
  locationUrl: "",
  email: "",
);
WisdomRequests defaultWisdomRequests = WisdomRequests(
  status: false,
  requests: [],
);

PatientRequest defaultPatientRequest = PatientRequest(
  age: 0,
  author: "",
  bloodGroup: 0,
  bloodReq: 0,
  dateTime: DateTime.now(),
  gender: 0,
  name: "",
  rejectedBy: [],
  status: false,
  ventReq: 0,
  acceptedBy: "",
  isCompleted: false,
);

List<BloodGroup> bloodGroups = [
  BloodGroup(0, "A+"),
  BloodGroup(1, "A-"),
  BloodGroup(2, "B+"),
  BloodGroup(3, "B-"),
  BloodGroup(4, "O+"),
  BloodGroup(5, "O-"),
  BloodGroup(6, "AB+"),
  BloodGroup(7, "AB-"),
];
