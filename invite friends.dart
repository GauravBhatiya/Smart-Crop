import 'package:flutter/material.dart';
import 'package:smart_crop/Home_page.dart';
import 'package:smart_crop/profile_page.dart';
import 'package:url_launcher/url_launcher.dart';

class InviteFriendsPage extends StatelessWidget {
  final String inviteCode;

  InviteFriendsPage({required this.inviteCode});

  void _inviteFriends() async {
    String message =
        'Hey! Join me on SmartCrop, use my invite code: $inviteCode';
    String url = 'https://wa.me/?text=${Uri.encodeComponent(message)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('        Invite Friends'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/images/invitation.png', // Replace with your image path
              height: 130, // Adjust height as needed
              width: 130, // Adjust width as needed
              fit: BoxFit.cover, // Adjust image fit as needed
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              'Invite friends to FarmRise',
              style: TextStyle(
                fontSize: 20, // Adjust size as needed
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
                height:
                    12), // Add some space between main heading and subheading
            // Subheading
            Text(
              "It's always so much fun \n with a friend around",
              style: TextStyle(
                fontSize: 16, // Adjust size as needed
                color: Colors.grey, // Adjust color as needed
              ),
            ),
            SizedBox(
                height: 40), // Add some space between subheading and button
            // Invite button
            ElevatedButton(
              onPressed: _inviteFriends,
              child: Text(
                'Invite Friends',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('      Privacy Policy'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal:
                        14.0), // Adjust the horizontal padding as needed
                child: Text(
                  'These Terms of Service (hereinafter "Terms") create a legal agreement between you and Monsanto Holdings Private Limited and its affiliates now also an affiliate of Bayer AG (hereinafter "Monsanto") pursuant to a specific request made by you to Monsanto to receive the SmartCrop services, including updates, new versions and any other messages pertaining to the requested services, and certain offers and information from our partners and affiliates in relation to the requested SmartCrop services (hereinafter the "SmartCrop Service"). By accessing, browsing, using, subscribing to, or registering for the SmartCrop Service, or any other explicit acceptance of these Terms, you acknowledge that you have the power and authority to enter into these Terms and have read, understood, and agree to be bound by these Terms. If you do not understand or agree to these Terms, then please do not register for or use the SmartCrop Service. \n\n 1. Authorized Users:- The SmartCrop Service is not for persons under the age of 18. If you are under 18 years of age, then please do not use the SmartCrop Service. \n\n 2. Our Use of the Services:- You may only use the SmartCrop Service for your own farming operations as authorized by these Terms. You agree that you will provide accurate, reliable and appropriate information and that you will keep your information up to date. When you register, you may be asked to provide a password. You should keep your password confidential. You are solely responsible for maintaining the confidentiality of your account and password and for restricting access to your account, and you are responsible for all activities that occur under your account or password. If you have reason to believe that your account is no longer secure (for example, in the event of a loss, theft or unauthorized disclosure or use of your account ID, password, or any credit, debit, or charge card number), you will immediately notify Monsanto. You will be liable for the losses incurred by Monsanto or others due to any unauthorized use of your account. No other rights or licenses to any Monsanto technology, services or intellectual property are granted by these Terms. You agree that none of the SmartCrop Service constitutes an essential public function. \n\n 3. Restrictions:- Any use of the SmartCrop Service or the SmartCrop Materials other than as permitted under these Terms or by applicable law, regulation, rule or act is strictly prohibited. Access to the SmartCrop Materials and the SmartCrop Service from territories where their contents are illegal is strictly prohibited. You are responsible for complying with all local rules, laws, and regulations including, without limitation, rules about intellectual property rights, the internet, technology, data, email, or privacy. In addition, you will not. \n\n 4. Use Requirements:- To use the SmartCrop Service, you will need working internet or cellular access, compatible software, and a device that meets the compatibility and system requirements, which may change from time to time. Monsanto does not guarantee that the SmartCrop Service or any connected computer system/network/service will function on any particular hardware or devices. In addition, the SmartCrop Service may be subject to malfunctions and delays inherent to the use of the internet and electronic communications. These factors may influence the performance and your ability to use the SmartCrop Service. These system requirements are your responsibility.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _receiveNotifications = false;
  bool _isButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('         Notification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Receive Push Notifications',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: _receiveNotifications,
                  onChanged: (value) {
                    setState(() {
                      _receiveNotifications = value;
                      _isButtonEnabled =
                          true; // Enable button after switch change
                    });
                    // Show notification based on switch state
                    if (value) {
                      // Notification is on
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Center(child: Text('Notifications are now ON')),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      // Notification is off
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Center(child: Text('Notifications are now OFF')),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            SizedBox(
                height:
                    10), // Add some space between switch and additional text
            Text(
              'Enable push notification to receive \n timely advisories and updates',
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isButtonEnabled
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Homepage(),
                        ),
                      );
                    }
                  : null, // Disable button if not enabled
              child: Center(
                  child: Text(
                'Save Updates',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
