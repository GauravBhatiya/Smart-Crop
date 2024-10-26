import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:share/share.dart';
import 'package:smart_crop/cart_page.dart';
import 'package:smart_crop/community.dart';
import 'package:smart_crop/explore_page.dart';
import 'package:smart_crop/fertilizer.dart';
import 'package:smart_crop/login.dart';
import 'package:smart_crop/news/news.dart';
import 'package:smart_crop/order_page.dart';
import 'package:smart_crop/profile_page.dart';
import 'package:smart_crop/registration.dart';
import 'package:smart_crop/services_page.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:smart_crop/store%20_image.dart';

import 'invite friends.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final pages = [
    const ExplorePage(),
    const ServicesPage(),
    CartPage(),
    Community(),
    const ProfilePage(),

  ];
  int currentIndex = 0;

  String Fname = "";
  String Lname = "";
  String email = "";

  void initState() {
    super.initState();
    _getDataFromFirebase();
  }

  Future<void> _getDataFromFirebase() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final User? user = _auth.currentUser;

      if (user != null) {
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          Fname = userDoc['firstName'] ?? 'Guest';
          Lname = userDoc['lastName'] ?? '';
          email = userDoc['email'] ?? '';
        });
      }
    } catch (e) {
      print("Error retrieving user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                '$Fname $Lname',
                style: TextStyle(color: Colors.white),
              ),
              accountEmail:
                  Text('$email', style: TextStyle(color: Colors.white)),
              currentAccountPicture: CircleAvatar(
                child: ProfilePicture(
                  name: '$Fname',
                  radius: 36,
                  fontsize: 25,
                  random: true,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.green.shade600,
                image: DecorationImage(
                  image: AssetImage('lib/images/a7.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 13,
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Homepage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Shoppings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Fertilizer()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.newspaper),
              title: Text('News'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Agriculture()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.analytics),
              title: Text('Market Analysis'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImageGridPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.question_answer_outlined),
              title: Text('Ask Questions'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AskQuestionPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.present_to_all),
              title: Text('Community'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Community()),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 180.0),
              child: ListTile(
                title: const Text("Logout",
                    style: TextStyle(
                      fontSize: 18,
                    )),
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
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello $Fname 👋",
              style: TextStyle(fontSize: 16, color: Colors.green.shade800),
            ),
            Text(
              "Enjoy our services",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton.filledTonal(
              onPressed: () {
                Share.share("https://play.google.com/store/games?device=phone");
              },
              icon: Icon(Icons.share,color: Colors.green.shade700,),
            ),
          ),
        ],
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(IconlyLight.home),
              activeIcon: Icon(IconlyBold.home),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(IconlyLight.bag),
              activeIcon: Icon(IconlyBold.bag),
              label: "Services"),
          BottomNavigationBarItem(
              icon: Icon(IconlyLight.buy),
              activeIcon: Icon(IconlyBold.buy),
              label: "Cart"),
          BottomNavigationBarItem(
              icon: Icon(IconlyLight.chat),
              activeIcon: Icon(IconlyBold.chat),
              label: "Community"),
          BottomNavigationBarItem(
              icon: Icon(IconlyLight.profile),
              activeIcon: Icon(IconlyBold.profile),
              label: "Profile"),
        ],
      ),
    );
  }
}
