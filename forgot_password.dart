import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.envelope,
              size: 120,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Forgot Password",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "If you have forgotten your password, \n you can change a new password by \n entering your email in the box below.",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,color: Colors.grey),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Enter your email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
              onPressed: () {
                _resetPassword(context);
              },
              child: Text("Reset Password",style: TextStyle(fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(child: Text("Password reset email sent!")),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Return to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(child: Center(child: Text("Failed to send password reset email.\n                Please try again."))),
          backgroundColor: Colors.green.shade900,
        ),
      );
    }
  }
}