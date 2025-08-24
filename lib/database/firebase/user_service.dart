import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final auth = FirebaseAuth.instance;
  Future<bool> createUser(String email, String password) async {
    try {
      auth.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> signInUser({required String email, required String password}) async {
    try {
      auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
