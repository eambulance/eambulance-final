class AmbulanceUser {
  String name;
  String email;
  String phone;
  String vhNo;
  String uid;
  AmbulanceUser({this.email, this.name, this.phone, this.uid, this.vhNo});

  factory AmbulanceUser.fromMap(Map map) {
    return AmbulanceUser(
      email: map["email"],
      phone: map["phone"],
      uid: map["uid"],
      name: map["name"],
      vhNo: map["vhNo"],
    );
  }
}
