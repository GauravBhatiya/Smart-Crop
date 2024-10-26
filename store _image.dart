import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_crop/Home_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ImageGridPage extends StatefulWidget {
  @override
  State<ImageGridPage> createState() => _ImageGridPageState();
}

class _ImageGridPageState extends State<ImageGridPage> {
  // bool isFollowing = false;

  // List of image paths
  final List<List<String>> images = [
    ['lib/images/carrots.png', 'lib/images/brinjal.png', 'lib/images/l2.jpeg'],
    [
      'lib/images/mango.png',
      'lib/images/pineapple.png',
      'lib/images/tomato.png'
    ],
    ['lib/images/apple.png', 'lib/images/bean.png', 'lib/images/cabbage.png'],
    ['lib/images/citrus.png', 'lib/images/ginger.png', 'lib/images/melon.png'],
    ['lib/images/okra.png', 'lib/images/pigeonpea.png', 'lib/images/rice.png'],
    [
      'lib/images/sugarcane.png',
      'lib/images/sugarcane.png',
      'lib/images/wheat.png'
    ],
    [
      'lib/images/soybean.png',
      'lib/images/pomegranate.png',
      'lib/images/millet.png'
    ],
  ];

  List<List<String>> imageNames = [
    ['Carrort'],
    ['Mango'],
    ['Apple'],
    ['Citrus'],
    ['Okra'],
    ['Sugaecan'],
    ['Soybean'],
  ];

  List<List<String>> cities = [
    ['Surat', 'Ahemdabad', 'Amreli', 'Bhavnager', 'Jamnager'],
    ['Ahemdabad', 'Vadodra', 'Junagadh', 'Surat', 'Rajkot'],
    ['Amreli', 'Bhavnager', 'Surat', 'Vadodra', 'Ahemdabad'],
    ['Bhavnager', 'Amreli', 'Vadodra', 'Surat', 'Rajkot'],
    ['Ahemdabad', 'Vadodra', 'Junagadh', 'Surat', 'Rajkot'],
    ['Amreli', 'Bhavnager', 'Surat', 'Vadodra', 'Ahemdabad'],
    ['Bhavnager', 'Amreli', 'Vadodra', 'Surat', 'Rajkot'],
  ];

  List<List<int>> prices = [
    [1350, 1450, 1350, 1250, 1050],
    [2250, 2300, 2100, 2500, 2400],
    [1200, 1050, 1400, 1350, 1600],
    [1600, 1500, 1700, 1550, 1800],
    [1050, 1100, 1050, 1500, 1200],
    [1800, 1750, 1850, 1900, 2000],
    [1950, 2000, 1950, 1750, 2150],
  ];

  final List<List<int>> _prices = [
    [1750, 1750, 1750, 1600, 1550],
    [2450, 2700, 2800, 3000, 2900],
    [2000, 1650, 1750, 1600, 1900],
    [1800, 1700, 1900, 1750, 2100],
    [1550, 1450, 1400, 1800, 1350],
    [2450, 2000, 2150, 2250, 2450],
    [2350, 2350, 2450, 2150, 2450],
  ];

  List<List<String>> kilometers = [
    ["20 km", "15 km", "20 km", "17 km", "19 km"],
    ["18 km", "17 km", "16 km", "19 km", "20 km"],
    ["22 km", "21 km", "23 km", "24 km", "25 km"],
    ["19 km", "18 km", "19 km", "18 km", "17 km"],
    ["18 km", "17 km", "16 km", "19 km", "20 km"],
    ["22 km", "21 km", "23 km", "24 km", "25 km"],
    ["19 km", "18 km", "19 km", "18 km", "17 km"],
  ];

  List<List<String>> Units = [
    ["20 kg", "18 kg", "22 kg", "20 kg", "25 kg"],
    ["30 kg", "25 kg", "20 kg", "40 kg", "35 kg"],
    ["22 kg", "18 kg", "26 kg", "30 kg", "24 kg"],
    ["18 kg", "16 kg", "22 kg", "17 kg", "15 kg"],
    ["20 kg", "22 kg", "20 kg", "21 kg", "25 kg"],
    ["30 kg", "32 kg", "25 kg", "28 kg", "32 kg"],
    ["25 kg", "28 kg", "20 kg", "35 kg", "30 kg"],
  ];

  List<List<bool>>? isFollowingList;

  @override
  void initState() {
    super.initState();
    _loadFollowStates();
  }

  Future<void> _loadFollowStates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFollowingList = List.generate(
        cities.length,
        (index) => List.generate(
          cities[index].length,
          (cityIndex) =>
              prefs.getBool('${cities[index][cityIndex]}_follow_state') ??
              false,
        ),
      );
    });
  }

  Future<void> _saveFollowState(
      int index, int cityIndex, bool isFollowing) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('${cities[index][cityIndex]}_follow_state', isFollowing);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: images.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size(120, 120),
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true,
              tabs: List.generate(
                images.length,
                (index) => Container(
                  height: 130,
                  child: Tab(
                    icon: Image.asset(
                      images[index].first,
                      width: 60,
                      height: 80,
                    ),
                    text: imageNames[index].first,
                  ),
                ),
              ),
            ),
          ),
          elevation: 0, // Remove app bar elevation
          centerTitle: true,
          title: const Text(
            'Market Price',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Homepage(),
                ),
              );
            },
          ),
        ),
        body: Expanded(
          child: TabBarView(
            children: List.generate(
              cities.length,
              (index) => ListView.builder(
                itemCount: cities[index].length,
                itemBuilder: (context, cityIndex) {
                  return SizedBox(
                    height: 170,
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      elevation: 2,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    cities[index][cityIndex],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  '\₹${prices[index][cityIndex]} - \₹${_prices[index][cityIndex]}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(
                                  Icons.arrow_downward,
                                  size: 20,
                                  color: Colors.red,
                                ),
                                const Icon(
                                  Icons.arrow_upward,
                                  size: 20,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        kilometers[index][cityIndex],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      Units[index][cityIndex],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                SizedBox(
                                  width: 90,
                                  height: 40,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isFollowingList![index][cityIndex] =
                                            !isFollowingList![index][cityIndex];
                                        _saveFollowState(index, cityIndex,
                                            isFollowingList![index][cityIndex]);
                                      });
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        isFollowingList![index][cityIndex]
                                            ? Colors.grey.shade800
                                            : Colors.green.shade800,
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      isFollowingList![index][cityIndex]
                                          ? 'Unfollow'
                                          : '+ Follow',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 70),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PieChartScreen(
                                          imageNames: imageNames[index],
                                          prices: prices[index],
                                          cities: cities[index],
                                          kilometers: kilometers[index],
                                          images: images[index],
                                          cityName: cities[index][cityIndex],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Current Price',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.green.shade800,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 3),
                                      const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 18,
                                        color: Colors.green,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class PieChartScreen extends StatelessWidget {
  final List<String> imageNames;
  final List<String> cities;
  final List<int> prices;
  final List<String> kilometers;
  final List<String> images;
  final String cityName;

  bool isFollowing = false;

  PieChartScreen({
    Key? key,
    required this.cities,
    required this.prices,
    required this.imageNames,
    required this.kilometers,
    required this.images,
    required this.cityName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('lib/images/v4.webp'), fit: BoxFit.cover),
            ),
          ),
          Positioned(
            top: 35,
            left: 15,
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImageGridPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    const Text(
                      'Price Analysis',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 105, // adjust this value to position the text vertically
            left: 90, // adjust this value to position the text horizontally
            child: Column(
              children: [
                Row(
                  children: [
                    Positioned(
                      top:
                          120, // adjust this value to position the image vertically
                      left:
                          20, // adjust this value to position the image horizontally
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black, width: 2), // black border
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          width: 80, // adjust size as needed
                          height: 80, // adjust size as needed
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(images.first),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      imageNames.first,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 220.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 20),
                          child: Text(
                            cityName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 0),
                      child: Text(
                        kilometers.first,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Price Trends',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 160.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_downward,
                                          size: 28,
                                          color: Colors.red,
                                        ),
                                        Icon(
                                          Icons.arrow_upward,
                                          size: 28,
                                          color: Colors.green,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Divider(
                        color: Colors.grey, // Choose your divider color
                        thickness: 2.0, // Choose the thickness of the divider
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '1 April 2024',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '100 Kg',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '₹1600 -₹2100',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 12.0, right: 12.0),
                          child: Divider(
                            color: Colors.grey, // Choose your divider color
                            thickness:
                                2.0, // Choose the thickness of the divider
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '4 April 2024',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '50 Kg',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '₹1100 - ₹1600',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 12.0, right: 12.0),
                          child: Divider(
                            color: Colors.grey, // Choose your divider color
                            thickness:
                                2.0, // Choose the thickness of the divider
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '8 April 2024',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '120 Kg',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '₹1700 - ₹2400',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.grey[200],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 6,
                              blurRadius: 10,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ], // Background color of the box
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Are the prices accurate?',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.thumb_up_alt_outlined,
                                      color: Colors.green),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Center(
                                            child: Text(
                                                'Thank you for providing your \n        valuable feedback!')),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                    width: 8), // Spacer between icon and text
                                const Text(
                                  'Yes',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                    width: 50), // Spacer between buttons
                                IconButton(
                                  icon: const Icon(
                                      Icons.thumb_down_alt_outlined,
                                      color: Colors.red),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Center(
                                            child: Text(
                                                'Thank you for providing your \n        valuable feedback!')),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                    width: 8), // Spacer between icon and text
                                const Text(
                                  'No',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 135.0),
                      child: Text(
                        'Pie Chart',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 65.0),
                      child: Text(
                        '(Price Analyisis on Different Cities)',
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Divider(
                        color: Colors.grey, // Choose your divider color
                        thickness: 2.0, // Choose the thickness of the divider
                      ),
                    ),
                    const SizedBox(
                        height:
                            20), // Add some space between the text and the chart
                    Center(
                      child: SfCircularChart(
                        series: <PieSeries<Map<String, dynamic>, String>>[
                          PieSeries<Map<String, dynamic>, String>(
                            dataSource: _generateData(),
                            xValueMapper: (Map<String, dynamic> data, _) =>
                                data['x'],
                            yValueMapper: (Map<String, dynamic> data, _) =>
                                data['y'],
                            dataLabelSettings:
                                const DataLabelSettings(isVisible: true),
                          ),
                        ],
                        legend: const Legend(
                          isVisible: true,
                          overflowMode: LegendItemOverflowMode.wrap,
                          orientation: LegendItemOrientation.vertical,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _generateData() {
    List<Map<String, dynamic>> data = [];
    for (int i = 0; i < cities.length; i++) {
      data.add({
        'x': cities[i], // City name as the x-value
        'y': prices[i], // Price as the y-value
      });
    }
    return data;
  }
}
