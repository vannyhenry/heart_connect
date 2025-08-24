import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heart_connect_app/models/assignment.dart';

final _instance = FirebaseFirestore.instance;
String uid = FirebaseAuth.instance.currentUser!.uid;

class AssignmentService {
  final _db = _instance.collection("users").doc(uid).collection("assignments");
  Future<bool?> addAssignment(AssignmentModal assignmentModal) async {
    try {
      await _db.doc().set(assignmentModal.toMap());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<List<AssignmentModal>> readAssignments() {
    return _db.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => AssignmentModal.fromFirestore(doc))
          .toList();
    });
  }
}
