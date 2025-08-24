import 'package:flutter/material.dart';
import 'package:heart_connect_app/assignments.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [Colors.deepPurple.shade900, Colors.blueGrey.shade900]
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Assignments'),
          backgroundColor: Colors.blueGrey,
          elevation: 4,
          shadowColor: Colors.black,
        ),
        body:
            assignmentList.isEmpty
                ? const Center(child: Text('No assignments available'))
                : ListView.builder(
                  itemCount: assignmentList.length,
                  itemBuilder: (context, index) {
                    final doc = assignmentList[index];
      
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  elevation: 4,
                                  scrollable: true,
                                  backgroundColor: Colors.blueGrey.shade800,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  title: Row(
                                    children: [
                                      const Icon(
                                        Icons.assignment,
                                        color: Colors.blueAccent,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              doc.title,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              'Due: ${doc.dueDate}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  content: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      doc.details,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(context).pop(),
                                      child: const Text(
                                        'Close',
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade50,
                            border: Border.all(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 6,
                                color: Colors.black38,
                                offset: Offset(1, 2),
                              ),
                            ],
                          ),
      
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.assignment, color: Colors.blueAccent),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    doc.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    doc.cDate,
                                    style: const TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                              PopupMenuButton(
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                offset: Offset(50, 30),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                itemBuilder: (context) => [
                                    PopupMenuItem<int>(
                                      value: 1,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: const [
                                          Icon(Icons.delete, color: Colors.red),
                                          SizedBox(width: 8),
                                          Text('Delete'),
                                        ],
                                      ),
                                    ),
                                ],
                                onSelected: (value) {
                                  if (value == 1) {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            backgroundColor: Colors.blueGrey.shade800,
                                            title: const Text('Confirm Delete', 
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            content: const Text(
                                              'Are you sure you want to delete this assignment?',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                () => Navigator.of(context).pop(),
      
                                                child: const Text('Cancel', 
                                                style: TextStyle(color: Colors.blueAccent),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  // doc.reference.delete().then(
                                                  //     (_) => Navigator.of(context).pop());
                                                },
                                                child: const Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
