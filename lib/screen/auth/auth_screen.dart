import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heart_connect_app/database/firebase/user_service.dart';
import 'package:heart_connect_app/screen/auth/auth_gate.dart';
import 'package:heart_connect_app/screen/display_assignment/display_assignments.dart';
import 'package:heart_connect_app/widgets/misc.dart';

class AuthScreen extends StatefulWidget {
  final FirebaseAuth auth;
  const AuthScreen({super.key, required this.auth});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isRegister = false; // Toggles between login and registration mode
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (FirebaseAuth.instance.authStateChanges() == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthGate()),
      );
    }
  }

  /// Handles the submission of the authentication form (login or registration).
  Future<void> _handleSubmit() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_isRegister) {
        // Register new user with email and password
        final check = await UserService().createUser(
          _emailController.text,
          _passwordController.text,
        );
        if (check) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AssignmentListScreen()),
          );
        }
      } else {
        // Sign in existing user with email and password
        final check = await UserService().signInUser(
          email: _emailController.text,
          password: _passwordController.text,
        );
        if (check) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AssignmentListScreen())
          );
        }
      }
    } on FirebaseAuthException {
      // Handle Firebase authentication errors
      displaySnackBar(context, "An error occured");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE0F7FA),
                  Color(0xFFEDE7F6),
                ], // Light blue to light purple
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                // Allows content to scroll on smaller screens
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 10,
                  child: Container(
                    padding: const EdgeInsets.all(32.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      border: const Border(
                        top: BorderSide(
                          color: Colors.deepPurple,
                          width: 8,
                        ), // Top border for styling
                      ),
                    ),
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // Column takes minimum space needed
                      children: [
                        Text(
                          _isRegister ? 'Register' : 'Login',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 32),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            hintText: 'you@example.com',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: true, // Hides password input
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: '••••••••',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            prefixIcon: const Icon(Icons.lock_outline),
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity, // Button takes full width
                          child: ElevatedButton(
                            onPressed:
                                _isLoading
                                    ? null
                                    : _handleSubmit, // Disable button while loading
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              elevation: 5,
                            ),
                            child:
                                _isLoading
                                    ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    )
                                    : Text(
                                      _isRegister ? 'Register' : 'Login',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isRegister =
                                  !_isRegister; // Toggle registration/login mode
                              _emailController
                                  .clear(); // Clear fields on toggle
                              _passwordController.clear();
                            });
                          },
                          child: Text(
                            _isRegister
                                ? 'Already have an account? Login'
                                : "Don't have an account? Register",
                            style: const TextStyle(color: Colors.deepPurple),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
