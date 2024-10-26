import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_crop/Home_page.dart';
import 'package:smart_crop/forgot_password.dart';
import 'package:smart_crop/onbording.dart';
import 'package:smart_crop/registration.dart';

class signing extends StatefulWidget {
  @override
  _signingState createState() => _signingState();
}

class _signingState extends State<signing> {

  bool _isPasswordVisible = false;
  bool isEmailValid = false;
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('lib/images/a7.jpeg'), fit: BoxFit.cover),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 70.0, left: 22),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(
                        fontSize:50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "Welcome! \n Please log in to continue",
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
            padding: const EdgeInsets.only(top: 240.0),
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
                            return 'Please enter your valid email';
                          }
                          return null;
                        },
                        controller: _emailController,
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your valid password';
                          }
                          return null;
                        },
                        obscureText: !_isPasswordVisible, // Update this line
                        controller: _passwordController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                            color: Colors.grey,
                          ),
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
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xff281537),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 90,
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
                        onPressed: () async {

                          try{
                            if (formKey.currentState!.validate()) {
                              UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
                              if(userCredential.user!.emailVerified){
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => Onboarding()),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(child: Text('Successfully Logged In')),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(child: Text('Please verify your email before login.')),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            }
                          }catch (e) {
                            print(e);
                          }
                        },
                        child: const Text(
                          "SIGN IN",
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
                              "Don't have account?",
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
                                    builder: (context) => const Registration(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Sign up",
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
