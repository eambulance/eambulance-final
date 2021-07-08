import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:x_ambulances/epic.dart';
import 'package:x_ambulances/models/HUser.dart';
import 'package:x_ambulances/models/PatientRequest.dart';
import 'package:x_ambulances/screens/cases.dart';
import 'package:x_ambulances/screens/completed.dart';
import 'package:x_ambulances/screens/new_request.dart';
import 'package:x_ambulances/services/auth.dart';
import 'package:x_ambulances/services/db.dart';
import 'package:x_ambulances/services/location.dart';

class HomeProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<WisdomHospitals>.value(
          value: XDB().wisdomHospitals(),
          initialData: defaultWisdomHopsitals,
        ),
        StreamProvider<WisdomRequests>.value(
          value: XDB().wisdomRequests(),
          initialData: defaultWisdomRequests,
        ),
        StreamProvider<LocationData>.value(
          value: XLocation().getLocation(),
          initialData: null,
        ),
      ],
      child: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIx = 0;
  void _updateIx(int i) {
    setState(() {
      _currentIx = i;
    });
  }

  Widget _bodyItem() {
    switch (_currentIx) {
      case 0:
        return NewRequestScreen();
        break;
      case 1:
        return AcceptedRequests();
        break;
      case 2:
        return CompletedRequestsScreen();
        break;
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("E-Ambulances"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              XAuth().logOut();
            },
          ),
        ],
      ),
      body: _bodyItem(),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 2,
        backgroundColor: Colors.black38,
        currentIndex: _currentIx,
        onTap: (ix) => _updateIx(ix),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.description,
            ),
            label: "New Request",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.schedule,
            ),
            label: "Requests",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.done,
            ),
            label: "Completed",
          ),
        ],
      ),
    );
  }
}
