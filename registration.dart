import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_crop/Home_page.dart';
import 'package:smart_crop/email_verification.dart';
import 'package:smart_crop/login.dart';
import 'package:smart_crop/onbording.dart';

class Registration extends StatelessWidget {
  const Registration({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController gmailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    Future<void> signUp(BuildContext context) async {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: gmailController.text.trim(),
                password: passwordController.text.trim());

        await userCredential.user?.sendEmailVerification();
        // Store additional user information in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'email': gmailController.text,
          'password': passwordController.text
        });

      } on FirebaseAuthException catch (e) {
        print("Error: ${e.message}");
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('lib/images/a7.jpeg'),fit: BoxFit.cover),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 70.0, left: 22),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Registration",
                    style: TextStyle(
                        fontSize:43,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "Welcome! \n Please create account",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 235.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                        controller: firstNameController,
                        decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.check, color: Colors.grey),
                            label: Text(
                              "First name",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          prefixIcon: Icon(Icons.supervised_user_circle_rounded),
                        ),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Last name';
                          }
                          return null;
                        },
                        controller: lastNameController,
                        decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.check, color: Colors.grey),
                            label: Text(
                              "Last name",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          prefixIcon: Icon(Icons.supervised_user_circle_rounded),
                        ),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Please enter valid email address';
                          }
                          return null;
                        },
                        controller: gmailController,
                        decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.check, color: Colors.grey),
                            label: Text(
                              "Email",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        controller: passwordController,
                        decoration: const InputDecoration(
                          suffixIcon:
                              Icon(Icons.visibility_off, color: Colors.grey),
                          label: Text(
                            "Password",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          prefixIcon: Icon(Icons.key),
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                            const Size(250, 50),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.green.shade900,
                          ),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            signUp(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Center(child: Text('Account Created Successfully')),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => EmailVerification()),
                            );
                          }
                        },
                        child: const Text(
                          "SIGN UP",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Do you have an account?",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 15),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => signing()),
                                );
                              },
                              child: const Text(
                                "Sign in",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
