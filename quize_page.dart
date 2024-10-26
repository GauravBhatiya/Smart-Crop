import 'package:flutter/material.dart';
import 'package:smart_crop/Home_page.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  String? selectedOption;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('       Quiz Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Align children at the center horizontally
              children: [
                Center( // Center the image horizontally
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 5.0), // Adjust spacing as needed
                    child: Image.asset(
                      'lib/images/g1.jpg', // Add your image path here
                      width: 230, // Adjust width as needed
                      height: 230, // Adjust height as needed
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15,),
            Center(
              child: Text(
                'Q.  Choose what describes you best?',
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 25),
            RadioListTile<String>(
              title: Text('I grow crops in fields',style: TextStyle(fontSize: 16)),
              value: 'I grow crops in fields',
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                  errorMessage = '';
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Adjust the border radius as needed
                side: BorderSide(color: Colors.grey), // Adjust the border color as needed
              ),
              controlAffinity: ListTileControlAffinity.trailing, // Align the selection button to the right
            ),
            SizedBox(height: 10),
            RadioListTile<String>(
              title: Text('I grow crops in my home garden',style: TextStyle(fontSize: 16)),
              value: 'I grow crops in my home garden',
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                  errorMessage = '';
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Adjust the border radius as needed
                side: BorderSide(color: Colors.grey), // Adjust the border color as needed
              ),
              controlAffinity: ListTileControlAffinity.trailing, // Align the selection button to the right
            ),
            SizedBox(height: 10),
            RadioListTile<String>(
              title: Text('I grow crops in pots',style: TextStyle(fontSize: 16)),
              value: 'I grow crops in pots',
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                  errorMessage = '';
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Adjust the border radius as needed
                side: BorderSide(color: Colors.grey), // Adjust the border color as needed
              ),
              controlAffinity: ListTileControlAffinity.trailing, // Align the selection button to the right
            ),
            SizedBox(height: 10),
            RadioListTile<String>(
              title: Text('Others',style: TextStyle(fontSize: 16)),
              value: 'Others',
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                  errorMessage = '';
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Adjust the border radius as needed
                side: BorderSide(color: Colors.grey), // Adjust the border color as needed
              ),
              controlAffinity: ListTileControlAffinity.trailing, // Align the selection button to the right
            ),
            SizedBox(height: 35),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (selectedOption != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Homepage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(child: Text("Please Select the option",style: TextStyle(color: Colors.black,fontSize: 16),)),
                        backgroundColor: Colors.white,
                        duration: Duration(seconds: 2), // Adjust the duration as needed
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(160, 45),
                  backgroundColor: Colors.green.shade500,
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
