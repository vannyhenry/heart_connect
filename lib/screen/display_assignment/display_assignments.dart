import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heart_connect_app/database/firebase/assignment_service.dart';
import 'package:heart_connect_app/screen/add_assignment/add_assignment_screen.dart';
import 'package:heart_connect_app/widgets/assignment_card.dart';

class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({super.key});

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}

class _AssignmentListScreenState extends State<AssignmentListScreen> {
  Future<void> refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignments'),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: StreamBuilder(
          stream: AssignmentService().readAssignments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No assignments yet. Tap + to add!'));
            }

            final assignments = snapshot.data!;

            return ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: assignments.length,
              itemBuilder: (context, index) {
                final assignmentDetails = assignments[index];
                return AssignmentCard(
                  assignment: assignmentDetails,
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => AddAssignmentScreen(
                              assignment: assignmentDetails,
                            ),
                      ),
                    );
                  },
                  onDelete: () async {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: Text('Delete "${assignmentDetails.title}"?'),
                            content: Text(
                              'Are you sure you want to delete this assignment?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();

                                  // Then perform delete if widget is still mounted
                                  if (mounted) {
                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(uid)
                                        .collection('assignments')
                                        .doc(assignmentDetails.id)
                                        .delete();
                                  }
                                },
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddAssignmentScreen()),
            );
          },
          icon: Icon(Icons.add),
        ),
      ),
    );
  }
}
