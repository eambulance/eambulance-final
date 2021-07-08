class HospitalUser {
  String name;
  String uid;
  String email;
  String location;
  String locationUrl;
  HospitalUser(
      {this.email, this.location, this.locationUrl, this.name, this.uid});

  factory HospitalUser.fromMap(Map map) {
    return HospitalUser(
      uid: map["uid"],
      name: map["name"],
      location: map["location"],
      locationUrl: map["locationURL"],
      email: map["email"],
    );
  }
}

class WisdomHospitals {
  bool status;
  List<HospitalUser> hospitals;
  WisdomHospitals({this.hospitals, this.status});
}
