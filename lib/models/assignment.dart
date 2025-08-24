import 'package:cloud_firestore/cloud_firestore.dart';

class AssignmentModal {
  final String? id;
  final String title;
  final String subject;
  final String description;
  final DateTime dueDate;
  final String priority;
  final String status;
  final String userId;

  AssignmentModal({
    this.id,
    required this.title,
    required this.subject,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.userId,
  });

  // Convert Firestore document to Assignment
  factory AssignmentModal.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return AssignmentModal(
      id: doc.id,
      title: data['title'] ?? '',
      subject: data['subject'] ?? '',
      description: data['description'] ?? '',
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      priority: data['priority'] ?? 'medium',
      status: data['status'] ?? 'pending',
      userId: data['userId'] ?? '',
    );
  }

  // Convert Assignment object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subject': subject,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'priority': priority,
      'status': status,
      'userId': userId,
    };
  }
}
