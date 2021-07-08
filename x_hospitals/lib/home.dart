import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_hospitals/epic.dart';
import 'package:x_hospitals/models/HUser.dart';
import 'package:x_hospitals/models/PatientRequest.dart';
import 'package:x_hospitals/screens/accepted_requests.dart';
import 'package:x_hospitals/screens/active_requests.dart';
import 'package:x_hospitals/utils/auth.dart';
import 'package:x_hospitals/utils/db.dart';

class HomeProvider extends StatefulWidget {
  @override
  _HomeProviderState createState() => _HomeProviderState();
}

class _HomeProviderState extends State<HomeProvider> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<WisdomRequests>.value(
          value: XDB().wisdomRequests(),
          initialData: defaultWisdomRequests,
        ),
        StreamProvider<WisdomHospitals>.value(
          value: XDB().wisdomHospitals(),
          initialData: defaultWisdomHopsitals,
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
        return ActiveRequests();
        break;
      case 1:
        return AcceptedRequests();
        break;
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Console"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              XAuth().signOut();
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
              Icons.schedule,
            ),
            label: "Requests",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.done,
            ),
            label: "Accepted",
          ),
        ],
      ),
    );
  }
}
