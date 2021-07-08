import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:x_hospitals/home.dart';
import 'package:x_hospitals/screens/boarding.dart';
import 'package:x_hospitals/utils/auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            home: Container(
              child: Center(
                child: Text("Error: ${snapshot.error}"),
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              StreamProvider.value(value: XAuth().authState, initialData: null),
            ],
            builder: (context, widget) {
              User _user = Provider.of<User>(context);
              return MaterialApp(
                title: "Hopsitals Console",
                debugShowCheckedModeBanner: false,
                theme: ThemeData.dark(),
                home: _user != null ? HomeProvider() : AuthScreen(),
              );
            },
          );
        }
        return MaterialApp(
          home: Container(
            child: Center(
              child: LinearProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
