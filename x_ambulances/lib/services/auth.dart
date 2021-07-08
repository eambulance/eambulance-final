import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class XAuth {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User> get authState => _auth.authStateChanges();
  User get authUser => _auth.currentUser;
  Future<void> logOut() async {
    await _auth.signOut();
  }

  Future<bool> signUp(String email, String pass) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      Fluttertoast.showToast(msg: "Account created, finishing setup...");
      return true;
    } catch (err) {
      Fluttertoast.showToast(msg: "Error: ${err.message}");
      return false;
    }
  }

  Future<void> login(String email, String pass) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: pass);
    } catch (err) {
      Fluttertoast.showToast(msg: err.message);
    }
  }
}
