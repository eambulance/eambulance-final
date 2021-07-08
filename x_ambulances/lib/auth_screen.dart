import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:x_ambulances/services/auth.dart';
import 'package:x_ambulances/services/db.dart';

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
        title: Text("E-Ambulance"),
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

    await XAuth().login(email, pass);
  }

  @override
  Widget build(BuildContext context) {
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
        TextFormField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: "Email",
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            hintText: "you@something.com",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
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
  TextEditingController _phoneCtrl = new TextEditingController();
  TextEditingController _vehicleNo = new TextEditingController();
  bool _isObscure = true;

  void _signUp() async {
    String name = _nameCtrl.text.trim();
    String email = _emailCtrl.text.trim();
    String pass = _passCtrl.text.trim();
    String phone = _phoneCtrl.text.trim();
    String vhNo = _vehicleNo.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        pass.isEmpty ||
        phone.isEmpty ||
        vhNo.isEmpty) {
      Fluttertoast.showToast(msg: "All fields are required.");
      return;
    }

    await XAuth().signUp(email, pass);
    await XDB().setupProfile(
      name: name,
      phone: phone,
      email: email,
      vhNo: vhNo,
    );
  }

  void _next(BuildContext context) {
    FocusScope.of(context).nextFocus();
  }

  @override
  Widget build(BuildContext context) {
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
            TextFormField(
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
            SizedBox(
              height: 10,
            ),
            TextFormField(
              onEditingComplete: () => _next(context),
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Phone Number",
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                hintText: "In international format",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
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
            SizedBox(
              height: 10,
            ),
            TextFormField(
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
            SizedBox(
              height: 10,
            ),
            TextFormField(
              onEditingComplete: () => _signUp(),
              controller: _vehicleNo,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Ambulance Vehicle Number",
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                hintText: "KL-xx-Y-zzzz",
                border: OutlineInputBorder(),
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
