import 'dart:io';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';
import 'package:smart_crop/models/fertilizer_product.dart';
import 'Disease/indentifying_screen/identifying_screen.dart';
import 'Disease/store/image_capture_store.dart';
import 'data/fertilizer_product.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({
    super.key,
  });

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  File? _image;
  List<dynamic>? _output;
  bool _loading = false;

  final ImageCaptureStore _imageCaptureStore = ImageCaptureStore();

  @override
  Widget build(BuildContext context) {
    _startChat(BuildContext context) async {
      dynamic conversationObject = {
        'appId': '1c717a12b73711154a54c50334be6203e',
      };

      KommunicateFlutterPlugin.buildConversation(conversationObject);
    }

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "What Service are you looking for?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.lightGreen[900],
            ),
          ),
          const SizedBox(height: 5),
          const Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Row(
              children: [],
            ),
          ),
          Container(
            child: CarouselSlider(
              options: CarouselOptions(
                height: 170.0,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 2),
                enlargeCenterPage: true,
                viewportFraction: 0.8,
              ),
              items: [
                'lib/images/c1.webp',
                'lib/images/c2.jpeg',
                'lib/images/c3.png',
                'lib/images/c5.jpg',
                'lib/images/c4.png',
              ].map((String imagePath) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 0.0),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(20.0), // Add border radius
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.2), // Set shadow color
                            spreadRadius: 0, // Set shadow spread radius
                            blurRadius: 5, // Set shadow blur radius
                            offset: Offset(0, 3), // Set shadow offset
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            15.0), // Clip container with border radius
                        child: Transform.scale(
                          scale:
                              1, // Adjust the scale factor for the central image
                          child: Image.asset(
                            imagePath, // Replace 'imagePath' with your actual image path
                            fit: BoxFit
                                .fill, // Fit the image inside the container without cropping
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 18),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Categories",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              // TextButton(onPressed: () {}, child: const Text("+ Add More")),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 135,
            child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        height: 87,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  Categoriess[index].image,
                                ))),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        Categoriess[index].name,
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                      width: 10,
                    ),
                itemCount: Categoriess.length),
          ),
          const SizedBox(height: 0),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SizedBox(
                height: 215,
                child: Card(
                  color: Colors.green.shade50,
                  elevation: 6,
                  shadowColor: Colors.green.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Free Consultation",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(color: Colors.green.shade900),
                              ),
                              const Text(
                                "Get free support from our customers services",
                                style: TextStyle(fontSize: 14.5),
                              ),
                              FilledButton(
                                  onPressed: () => _startChat(context),
                                  child: const Text(
                                    "Message now",
                                    style: TextStyle(fontSize: 14.2),
                                  )),
                            ],
                          ),
                        ),
                        Image.asset(
                          'lib/images/contact_us.png',
                          width: 150,
                        ),
                      ],
                    ),
                  ),
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Heal your crop",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextButton(onPressed: () {}, child: const Text("See all")),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Column(
            children: [
              SizedBox(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // ignore: unnecessary_null_comparison
                            // _image == null ? _showDesign() : _showImage(),
                            _showDesign()
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Center _showDesign() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 270,
          width: 300,
          color: const Color.fromRGBO(242, 242, 242, 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 180,
                width: 300,
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 25.0, left: 20, right: 20),
                      child: FittedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: Image.asset('assets/leaf.png'),
                            ),
                            const SizedBox(
                              child: Padding(
                                padding: EdgeInsets.only(left: 5, top: 20.0),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 30,
                                  color: Color.fromRGBO(201, 193, 193, 0.9),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: Image.asset('assets/done.png'),
                            ),
                            const SizedBox(
                              child: Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 30,
                                  color: Color.fromRGBO(201, 193, 193, 0.9),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: Image.asset('assets/fertilizer.png'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 25.0, top: 10),
                      child: Row(
                        children: [
                          Text(" Take a \n Picture"),
                          Padding(
                            padding: EdgeInsets.only(left: 45.0),
                            child: Text("\t\t\t\t\tSee \n diagnosis"),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30.0),
                            child: Text("\t\t\t\t\tGet \n medicine"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SizedBox(
                        width: 250,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(16, 25, 239, 0.9),
                          ),
                          onPressed: () async {
                            bool canNavigate = await _imageCaptureStore
                                .pickImage(ImageSource.camera);
                            if (canNavigate) {
                              if (context.mounted) {
                                Navigator.pushNamed(
                                  context,
                                  IdentifyingScreen.routeName,
                                  arguments:
                                      _imageCaptureStore.mediaFileList.last,
                                );
                              }
                            }
                          },
                          child: const Text(
                            'Take A Picture',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
