import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_crop/Home_page.dart';

class Community extends StatefulWidget {
  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  int thumbsUpCount = 0;
  int thumbsDownCount = 0;
  bool thumbsUpClicked = false;
  bool thumbsDownClicked = false;

  void _handleThumbsUp() {
    setState(() {
      thumbsUpClicked = !thumbsUpClicked;
      if (thumbsUpClicked) {
        thumbsUpCount++;
      } else {
        thumbsUpCount--;
      }
    });
  }

  void _handleThumbsDown() {
    setState(() {
      thumbsDownClicked = !thumbsDownClicked;
      if (thumbsDownClicked) {
        thumbsDownCount++;
      } else {
        thumbsDownCount--;
      }
    });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> _getDataFromFirebase(String userId) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    return userDoc.data() as Map<String, dynamic>? ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('questions').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final questions = snapshot.data!.docs;

          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];

              return FutureBuilder<Map<String, dynamic>>(
                future: _getDataFromFirebase(question['userId']),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final userData = snapshot.data ?? {};
                  final FName = userData['firstName'] ?? '';
                  final LName = userData['lastName'] ?? '';
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(
                              20), // Adjust the radius as needed
                          bottom: Radius.circular(
                              20), // Adjust the radius as needed
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            question['image'],
                            height: 170,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        CupertinoIcons.person_crop_circle,
                                        size: 30,
                                        color: Colors.green,
                                      ),
                                      Text(
                                        ' $FName $LName'.toUpperCase(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    question['question'],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    question['description'],
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 8),
                                  const Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        onPressed: _handleThumbsUp,
                                        icon: Icon(
                                          Icons.thumb_up,
                                          color: thumbsUpClicked
                                              ? Colors.blue
                                              : null,
                                          size: 23,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '$thumbsUpCount',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(width: 10),
                                      IconButton(
                                        onPressed: _handleThumbsDown,
                                        icon: Icon(
                                          Icons.thumb_down,
                                          color: thumbsDownClicked
                                              ? Colors.blue
                                              : null,
                                          size: 23,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        '$thumbsDownCount',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(width: 130),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CommentPage(),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.comment,
                                          size: 24, // Adjust the size as needed
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green.shade800,
        icon: const Icon(
          CupertinoIcons.pencil,
          color: Colors.white,
          size: 20,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AskQuestionPage()),
          );
        },
        label: const Text(
          "Ask Community",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class AskQuestionPage extends StatefulWidget {
  @override
  _AskQuestionPageState createState() => _AskQuestionPageState();
}

class _AskQuestionPageState extends State<AskQuestionPage> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? _image;

  Future<void> _sendQuestion() async {
    try {
      final pickedFile = _image;
      String? imagePath;
      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        final taskSnapshot = await FirebaseStorage.instance
            .ref()
            .child('question_images')
            .child(DateTime.now().millisecondsSinceEpoch.toString())
            .putFile(imageFile);
        imagePath = await taskSnapshot.ref.getDownloadURL();
      }

      final currentUser = _auth.currentUser;

      await FirebaseFirestore.instance.collection('questions').add({
        'userId': currentUser!.uid,
        'question': _questionController.text,
        'description': _descriptionController.text,
        'image': imagePath,
        'timestamp': Timestamp.now(),
      });

      Navigator.pop(context);
    } catch (error) {
      print('Error sending question: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('        Ask Question'),
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 200,
              child: _image != null
                  ? Image.file(_image!)
                  : ElevatedButton(
                onPressed: _pickImage,
                child: const Text(
                  'Attach Image',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                hintText: "Add a question indicating what's\nwrong with your crop",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      15.0), // Adjust the border radius as needed
                ),
              ),
              maxLength: 100,
              maxLines: null,
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: 'Describe specialities such as change\nof leaves,root colour,bugs, tears...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      15.0), // Adjust the border radius as needed
                ),
              ),
              maxLength: 250,
              maxLines: null,
            ),
            SizedBox(
              height: 80,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_image == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Center(child: Text('Please attach an image'),),
                        backgroundColor: Colors.green.shade900,),

                    );
                  } else if (_questionController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Center(child: Text('Please add a question')),
                        backgroundColor: Colors.green.shade900,),
                    );
                  } else if (_descriptionController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Center(child: Text('Please add a description')),
                        backgroundColor: Colors.green.shade900,),
                    );
                  } else {
                    _sendQuestion();
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(160, 45),
                  backgroundColor: Colors.green.shade700, // Adjust width and height as needed
                ),
                child: Text(
                  'Send',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
}



class CommentPage extends StatefulWidget {
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController _commentController = TextEditingController();

  Future<void> comment(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('comment')
          .add({
        'comment': _commentController.text,
      });
    } on FirebaseAuthException catch (e) {
      print("Error: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('          Comment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.asset(
                        'lib/images/comment.png',
                        width: 150,
                        height: 150,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "Comment",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "You can comment anything about \n   this photo crop or disease and \n          you can help the use.",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.grey),
                ),
              ),
              SizedBox(height: 25),
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: "Add a Comment indicating what's\nwrong with your crop",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                maxLength: 50,
                maxLines: null,
              ),
              SizedBox(height: 35),
              ElevatedButton(
                onPressed: () {
                  if (_commentController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(child: Text('Please add a comment')),
                        backgroundColor: Colors.green.shade900,
                      ),
                    );
                  } else {
                    comment(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Homepage()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(child: Text('Comment submitted successfully')),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: Text(
                  'Send',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
