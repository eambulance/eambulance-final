import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:x_ambulances/epic.dart';
import 'package:x_ambulances/models/BloodGroup.dart';
import 'package:x_ambulances/services/db.dart';

class NewRequestScreen extends StatefulWidget {
  @override
  _NewRequestScreenState createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends State<NewRequestScreen> {
  TextEditingController _nameCtrl = new TextEditingController();
  TextEditingController _ageCtrl = new TextEditingController();

  int _genderVal = -1;
  int _bloodReq = -1;
  int _ventReq = -1;
  void _selectGender(ix) {
    setState(() {
      _genderVal = ix;
    });
  }

  void _selectBR(ix) {
    setState(() {
      _bloodReq = ix;
    });
  }

  void _selectVent(ix) {
    setState(() {
      _ventReq = ix;
    });
  }

  List<DropdownMenuItem<BloodGroup>> _dropdownMenuItems;
  BloodGroup _selectedloodGroup;

  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(bloodGroups);
    _selectedloodGroup = _dropdownMenuItems[0].value;
  }

  List<DropdownMenuItem<BloodGroup>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<BloodGroup>> items = [];
    for (BloodGroup listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  Future<void> _requestNow(BuildContext context) async {
    String name = _nameCtrl.text.trim();
    String ageS = _ageCtrl.text.trim();
    if (name.isEmpty || ageS.isEmpty) {
      Fluttertoast.showToast(msg: "Name and age cannot be empty.");
      return;
    }
    int age = int.parse(ageS);
    if (_genderVal < 0 || _bloodReq < 0 || _ventReq < 0) {
      Fluttertoast.showToast(msg: "All fields are required");
      return;
    }

    if (age > 140 || age < 0) {
      Fluttertoast.showToast(msg: "Make sure age is correct!?");
      return;
    }

    bool x = await XDB().sendRequest(
      name: name,
      age: age,
      gender: _genderVal,
      bloodGroup: _selectedloodGroup.value,
      ventilatorReq: _ventReq,
      bloodReq: _bloodReq,
    );
    if (x) {
      _reset();
    }
    FocusScope.of(context).unfocus();
  }

  void _reset() {
    _nameCtrl.clear();
    _ageCtrl.clear();
    setState(() {
      _selectedloodGroup = bloodGroups[0];
      _bloodReq = -1;
      _ventReq = -1;
      _genderVal = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Text(
                "Enter Patient Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _nameCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: "Patient's Name",
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _ageCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Patient's Age",
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text("Gender: "),
                  Radio(
                    value: 0,
                    groupValue: _genderVal,
                    onChanged: _selectGender,
                  ),
                  Text("Male"),
                  Radio(
                    value: 1,
                    groupValue: _genderVal,
                    onChanged: _selectGender,
                  ),
                  Text("Female"),
                  Radio(
                    value: 2,
                    groupValue: _genderVal,
                    onChanged: _selectGender,
                  ),
                  Text("LGBTQ+"),
                ],
              ),
              Row(
                children: [
                  Text("Blood required? "),
                  Radio(
                    value: 0,
                    groupValue: _bloodReq,
                    onChanged: _selectBR,
                  ),
                  Text("Yes"),
                  Radio(
                    value: 1,
                    groupValue: _bloodReq,
                    onChanged: _selectBR,
                  ),
                  Text("No"),
                ],
              ),
              Row(
                children: [
                  Text("Blood Group: "),
                  SizedBox(
                    width: 10,
                  ),
                  DropdownButton<BloodGroup>(
                    value: _selectedloodGroup,
                    items: _dropdownMenuItems,
                    onChanged: (value) {
                      setState(() {
                        _selectedloodGroup = value;
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Ventilator required? "),
                  Radio(
                    value: 0,
                    groupValue: _ventReq,
                    onChanged: _selectVent,
                  ),
                  Text("Yes"),
                  Radio(
                    value: 1,
                    groupValue: _ventReq,
                    onChanged: _selectVent,
                  ),
                  Text("No"),
                  Radio(
                    value: 2,
                    groupValue: _ventReq,
                    onChanged: _selectVent,
                  ),
                  Text("May be"),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () => _requestNow(context),
                child: Text("Send Request"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
