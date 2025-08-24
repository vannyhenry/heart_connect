import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heart_connect_app/database/firebase/user_service.dart';
import 'package:heart_connect_app/widgets/misc.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  bool? firstLog;
  ProfileScreen({Key? key, required this.firstLog}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Variables to hold user info
  String name = "";
  String studentId = "";
  String email = "";
  String course = "";

  // TextEditingControllers for editing
  late TextEditingController nameController;
  late TextEditingController studentIdController;
  late TextEditingController emailController;
  late TextEditingController courseController;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    nameController = TextEditingController();
    studentIdController = TextEditingController();
    emailController = TextEditingController();
    courseController = TextEditingController();

    // Fetch user info
    if (widget.firstLog!) {

    } else {
      fetchUserInfo();
    }
  }

  Future<void> fetchUserInfo() async {
    final userInfo = await UserService().readUserInfo();
    setState(() {
      name = userInfo['name'] ?? '';
      studentId = userInfo['studentId'] ?? '';
      email = userInfo['email'] ?? '';
      course = userInfo['course'] ?? '';

      // Populate controllers
      nameController.text = name;
      studentIdController.text = studentId;
      emailController.text = email;
      courseController.text = course;

      isLoading = false;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    studentIdController.dispose();
    emailController.dispose();
    courseController.dispose();
    super.dispose();
  }

  // Function to save updated info
  void saveUserInfo() async {
    try {
      await UserService().userProfile(
        nameController.text,
        studentIdController.text,
        FirebaseAuth.instance.currentUser!.email!,
        courseController.text,
      );
    } catch (e) {
      displaySnackBar(context, "Error happened: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile'),
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: saveUserInfo),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Header with Name
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          nameController.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Editable TextFormFields
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: studentIdController,
                      decoration: const InputDecoration(
                        labelText: 'Student ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: courseController,
                      decoration: const InputDecoration(
                        labelText: 'Course',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
