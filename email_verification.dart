import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_crop/login.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.envelope,
              size: 120,
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "Verify your email address",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
                "We have just send email verification link on \n your email Please check email and click on \n       that link to verify to email address."),
            SizedBox(
              height: 60,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => signing()),
                );
              },
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back_outlined), // Add the logout icon
                          SizedBox(width: 5), // Add some space between the icon and the text
                          Text(
                            "Back to Login",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            )
          ],
        ),
      ),
    );
  }
}
