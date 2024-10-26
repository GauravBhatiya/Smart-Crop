import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_crop/feedback_page.dart';
import 'package:smart_crop/invite%20friends.dart';
import 'package:smart_crop/login.dart';
import 'package:smart_crop/order_page.dart';
import 'package:smart_crop/registration.dart';
import 'package:smart_crop/store%20_image.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  File? _image;
  String Fname = "";
  String Lname = "";
  String email = "";
  String newFirstName = '';
  String newLastName = '';

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _getImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // _getDataFromFirebase();
  }

  Future<void> _getDataFromFirebase() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    Fname = userDoc['firstName'] ?? 'Guest';
    Lname = userDoc['lastName'];
    email = userDoc['email'];
  }

  Future<void> _updateProfile(String newFirstName, String newLastName) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'firstName': newFirstName,
        'lastName': newLastName,
      });
      setState(() {
        Fname = newFirstName;
        Lname = newLastName;
      });
      print('Profile updated successfully');
    } catch (error) {
      print('Failed to update profile: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 15.0),
                  child: SizedBox(
                    height: 145,
                    child: GestureDetector(
                      onTap: () {
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 70,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: _image != null
                                ? CircleAvatar(
                              radius: 80,
                              backgroundImage: FileImage(_image!),
                            )
                                : const CircleAvatar(
                              radius: 80,
                              backgroundImage: AssetImage('assets/user.png'),
                            ),
                          ),
                          Positioned(
                            right: 110, // Adjust the value to move the icon further to the right
                            bottom: 10, // Adjust the value to move the icon further to the bottom
                            child: CircleAvatar(
                              radius: 20, // Adjust the radius of the edit icon circle
                              backgroundColor: Colors.white,
                              child: IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Choose an option"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              _getImageFromGallery();
                                            },
                                            child: const Text("Gallery"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              _getImageFromCamera();
                                            },
                                            child: const Text("Camera"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.edit_note, size: 28, color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    '$Fname $Lname',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    email,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                ListTile(
                  title: const Text(
                    "Profile Edit",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  leading: const Icon(Icons.edit),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              title: const Text('Update Profile'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  TextField(
                                    controller: _firstNameController,
                                    decoration: const InputDecoration(
                                      labelText: 'First Name',
                                      prefixIcon: Icon(Icons.supervised_user_circle_sharp),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        newFirstName = value;
                                      });
                                    },
                                  ),
                                  TextField(
                                    controller: _lastNameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Last Name',
                                      prefixIcon: Icon(Icons.supervised_user_circle_sharp),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        newLastName = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (newFirstName.isEmpty || newLastName.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Center(child: Text('Please fill in both first and last names')),
                                          backgroundColor: Colors.green.shade900,
                                        ),
                                      );
                                    } else {
                                      _updateProfile(newFirstName, newLastName);
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: const Text('Update'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  title: const Text(
                    "Mandi Market",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  leading: const Icon(Icons.currency_rupee_sharp),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageGridPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text(
                    "Invite Friends",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  leading: const Icon(Icons.mobile_friendly_outlined),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InviteFriendsPage(inviteCode: '2344564324',),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text(
                    "Feedback",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  leading: const Icon(Icons.feedback_outlined),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FeedbackPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text(
                    "Notification Preferences",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  leading: const Icon(Icons.notification_add_outlined),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text(
                    "Setting",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrivacyPolicyPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  leading: const Icon(Icons.logout_outlined),
                  onTap: () async {
                    bool logoutConfirmed = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text("Logout"),
                          content: Text("Are you sure you want to logout?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(
                                    false); // Return false when cancel button is pressed
                              },
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(
                                    true); // Return true when confirm button is pressed
                              },
                              child: Text("Logout"),
                            ),
                          ],
                        );
                      },
                    );
                    if (logoutConfirmed == true) {
                      // Navigate to the sign-in screen if logout is confirmed
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => signing()));
                    }
                  },
                ),
              ],
            );
          }
        },
        future: _getDataFromFirebase(),
      ),
    );
  }
}
