import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smart_crop/Home_page.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {

  final TextEditingController _emailController = TextEditingController();
  double _rating = 0;
  TextEditingController _feedbackController = TextEditingController();

  Future<void> feedback(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('feedback')
          .add({
        'feedback': _feedbackController.text,
        'email': _emailController.text
      });
    } on FirebaseAuthException catch (e) {
      print("Error: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('          Feedback'),
      ),
      body: SingleChildScrollView( // Wrap your Column with SingleChildScrollView
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rate your experience:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 40.0,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              SizedBox(height: 10),
              Text(
                'You rated: $_rating stars',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 10,),
              Visibility(
                visible: _rating >= 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '😊',
                      style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Excillent!',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _rating >= 2 && _rating < 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '😐',
                      style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Good',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _rating < 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '😞',
                      style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Bad!',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Feedback:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _feedbackController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter your feedback here...',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your email (compulsory)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 50),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_rating == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Center(child: Text('Please rate your experience')),
                          backgroundColor: Colors.green.shade900,
                        ),
                      );
                    } else if (_feedbackController.text.isEmpty || _emailController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Center(child: Text('Please provide your feedback and email')),
                          backgroundColor: Colors.green.shade900,
                        ),
                      );
                    } else {
                      feedback(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Homepage()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Center(child: Text('Feedback submitted successfully')),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

