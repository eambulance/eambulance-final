class PatientRequest {
  String name;
  int age;
  String author;
  int bloodGroup;
  int bloodReq;
  DateTime dateTime;
  int gender;
  List<String> rejectedBy;
  bool status;
  int ventReq;
  String docId;
  String acceptedBy;
  bool isCompleted;
  PatientRequest(
      {this.age,
      this.author,
      this.bloodGroup,
      this.bloodReq,
      this.dateTime,
      this.gender,
      this.name,
      this.rejectedBy,
      this.status,
      this.ventReq,
      this.docId,
      this.acceptedBy,
      this.isCompleted});

  factory PatientRequest.fromMap(Map map, String id) {
    return PatientRequest(
      age: map["age"],
      author: map["author"],
      bloodGroup: map["bloodGroup"],
      bloodReq: map["bloodReq"],
      dateTime: map["dateTime"].toDate(),
      gender: map["gender"],
      name: map["name"],
      rejectedBy: map["rejectedBy"].cast<String>(),
      status: map["status"],
      ventReq: map["ventReq"],
      acceptedBy: map["acceptedBy"],
      isCompleted: map["isCompleted"],
      docId: id,
    );
  }
}

class WisdomRequests {
  bool status;
  List<PatientRequest> requests;
  WisdomRequests({this.status, this.requests});
}
