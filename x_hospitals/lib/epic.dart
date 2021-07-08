import 'package:x_hospitals/models/HUser.dart';

import 'models/BloodGroup.dart';
import 'models/PatientRequest.dart';

WisdomHospitals defaultWisdomHopsitals = WisdomHospitals(
  status: false,
  hospitals: [],
);

WisdomRequests defaultWisdomRequests = WisdomRequests(
  status: false,
  requests: [],
);

HospitalUser defaultHospitalUser = HospitalUser(
  uid: "",
  name: "",
  location: "",
  locationUrl: "",
  email: "",
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
