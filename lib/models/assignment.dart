import 'package:cloud_firestore/cloud_firestore.dart';

class Assignment {
  final String? id;
  final String title;
  final String subject;
  final String description;
  final DateTime dueDate;
  final String priority;
  final String status;
  final String userId;

  Assignment({
    this.id,
    required this.title,
    required this.subject,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.userId,
  });

  // Only method you need - convert Firestore doc to Assignment
  factory Assignment.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return Assignment(
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
}