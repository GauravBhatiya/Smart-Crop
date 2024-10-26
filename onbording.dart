import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:smart_crop/Home_page.dart';
import 'package:smart_crop/models/content_model.dart';
import 'package:smart_crop/quize_page.dart';
import 'package:smart_crop/store%20_image.dart';

class Onboarding extends StatelessWidget {
  final List<PageViewModel> pages = contents
      .map(
        (content) => PageViewModel(
      title: content.title,
      body: content.discription,
      image: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: Container(
          height: 350,
          width: 300,
          child: SvgPicture.asset(
            content.image,
            fit: BoxFit.fill,
          ),
        ),
      ),
    ),
  )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center( // Centering the content
        child: IntroductionScreen(
          pages: pages,
          globalBackgroundColor: Colors.white,
          onDone: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>  QuizPage(),
              ),
            );
          },
          onSkip: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => QuizPage(),
              ),
            );
          },
          showSkipButton: true,
          skip: const Text("Skip", style: TextStyle(fontSize: 17)),
          next: const Text("Next", style: TextStyle(fontSize: 17)),
          done: const Text("Done", style: TextStyle(fontSize: 17)),
          dotsDecorator: DotsDecorator(
            size: const Size(7.0, 7.0),
            color: Colors.grey,
            activeColor: Colors.green,
            activeSize: const Size(30.0, 10.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          dotsContainerDecorator: const ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
        ),
      ),
    );
  }
}
