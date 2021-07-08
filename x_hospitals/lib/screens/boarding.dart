import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:x_hospitals/models/Coordinates.dart';
import 'package:x_hospitals/utils/auth.dart';
import 'package:x_hospitals/utils/db.dart';
import 'package:x_hospitals/utils/location.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  PageController _pageCtrl = PageController(initialPage: 0);

  void nav({bool front = true}) {
    _pageCtrl.animateToPage(
      front ? 1 : 0,
      duration: Duration(
        milliseconds: 300,
      ),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hospitals Console"),
      ),
      body: PageView(
        controller: _pageCtrl,
        children: [
          LoginPage(nav),
          SignUpPage(nav),
        ],
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  final Function nav;
  LoginPage(this.nav);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailCtrl = new TextEditingController();
  TextEditingController _passCtrl = new TextEditingController();
  bool _isObscure = true;

  Future<void> _login() async {
    String email = _emailCtrl.text.trim();
    String pass = _passCtrl.text.trim();
    if (email.isEmpty || pass.isEmpty) {
      Fluttertoast.showToast(msg: "All fields are required.");
      return;
    }

    await XAuth().signIn(email, pass);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Login".toUpperCase(),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          width: size.width > 600 ? size.width * 0.4 : 300,
          child: TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Email",
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              hintText: "you@something.com",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: size.width > 600 ? size.width * .4 : 300,
          child: TextFormField(
            controller: _passCtrl,
            obscureText: _isObscure,
            onEditingComplete: () => print("ok"),
            decoration: InputDecoration(
              labelText: "Password",
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              hintText: "********",
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              ),
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        ElevatedButton(
          onPressed: () => _login(),
          child: Text("LOGIN"),
        ),
        SizedBox(
          height: 20,
        ),
        Text("OR"),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
          ),
          onPressed: () => widget.nav(front: true),
          child: Text("SIGN UP"),
        ),
      ],
    );
    ;
  }
}

class SignUpPage extends StatefulWidget {
  final Function nav;
  SignUpPage(this.nav);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _emailCtrl = new TextEditingController();
  TextEditingController _passCtrl = new TextEditingController();
  TextEditingController _nameCtrl = new TextEditingController();
  TextEditingController _location = new TextEditingController();
  TextEditingController _locationURL = new TextEditingController();
  TextEditingController _latLong = new TextEditingController();

  Coordinates _coords;
  bool _isObscure = true;

  Future<void> _getLatLong() async {
    Coordinates coor = await XLocation().getLocation();
    if (coor == null) return;
    _latLong.text = "${coor.lat}, ${coor.lon}";
    _coords = coor;
  }

  void _signUp() async {
    String name = _nameCtrl.text.trim();
    String email = _emailCtrl.text.trim();
    String pass = _passCtrl.text.trim();
    String addr = _location.text.trim();
    String gmap = _locationURL.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        pass.isEmpty ||
        addr.isEmpty ||
        gmap.isEmpty) {
      Fluttertoast.showToast(msg: "All fields are required.");
      return;
    }

    if (_coords == null) {
      Fluttertoast.showToast(msg: "Please set coordinates.");
      return;
    }

    User x = await XAuth().signUp(email, pass);
    print("I HAVE FUCKING EMAIL HERE: ${XAuth().authUser.email}");
    if (x != null) {
      await XDB().setupProfile(
        user: x,
        name: name,
        location: addr,
        email: email,
        locationURL: gmap,
        lat: _coords.lat,
        lon: _coords.lon,
      );
    } else {
      Fluttertoast.showToast(msg: "Sign up failed");
    }
  }

  void _next(BuildContext context) {
    FocusScope.of(context).nextFocus();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sign Up".toUpperCase(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: size.width > 600 ? size.width * .4 : 300,
              child: TextFormField(
                onEditingComplete: () => _next(context),
                controller: _nameCtrl,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Name",
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  hintText: "Mia Joseph",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: size.width > 600 ? size.width * .4 : 300,
              child: TextFormField(
                onEditingComplete: () => _next(context),
                controller: _location,
                decoration: InputDecoration(
                  labelText: "Address:",
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  hintText: "City, District, State",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: size.width > 600 ? size.width * .4 : 300,
              child: TextFormField(
                onEditingComplete: () => _next(context),
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  hintText: "you@something.com",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: size.width > 600 ? size.width * .4 : 300,
              child: TextFormField(
                onEditingComplete: () => _next(context),
                controller: _passCtrl,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  labelText: "Password",
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  hintText: "********",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: size.width > 600 ? size.width * .4 : 300,
              child: TextFormField(
                onEditingComplete: () => _signUp(),
                controller: _locationURL,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Google Maps Link:",
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  hintText: "https://goo.gl/maps/...",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: size.width > 600 ? size.width * .4 : 300,
              child: TextFormField(
                onEditingComplete: () => _signUp(),
                controller: _latLong,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Latitude, Longitude:",
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  hintText: "8.1022, 75.123",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.location_on),
                    onPressed: () => _getLatLong(),
                  ),
                ),
                readOnly: true,
                onTap: () => _getLatLong(),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              onPressed: () => _signUp(),
              child: Text("SIGN UP"),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () => widget.nav(front: false),
              child: Text(
                "OR LOGIN",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
