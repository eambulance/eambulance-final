import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class XAuth {
  FirebaseAuth _auth = FirebaseAuth.instance;

  User get authUser => _auth.currentUser;
  Stream<User> get authState => _auth.authStateChanges();

  Future<void> signOut() async => await _auth.signOut();

  Future<void> signIn(String email, String password) async {
    try {
      _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (err) {
      Fluttertoast.showToast(msg: err.message);
    }
  }

  Future<User> signUp(String email, String password) async {
    try {
      return (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
    } catch (err) {
      print("ERROR OCCURED: $err");
      Fluttertoast.showToast(msg: err.message);
      return null;
    }
  }
}
