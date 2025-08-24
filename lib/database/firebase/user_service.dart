import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

String uid = FirebaseAuth.instance.currentUser!.uid;

class UserService {
  final auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance.collection("users");

  Future<bool> createUser(String email, String password) async {
    try {
      auth.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> userProfile(
    String studentName,
    String studentId,
    String email,
    String course,
  ) async {
    try {
      await _db.doc(uid).set({
        "studentName": studentName,
        'studentId': studentId,
        'email': email,
        'course': course,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future readUserInfo() async {
    return _db.doc(uid).snapshots();
  }
}
