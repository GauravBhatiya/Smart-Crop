import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_crop/cart_page.dart';
import 'package:smart_crop/data/fertilizer_product.dart';
import 'package:smart_crop/models/fertilizer_product.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

Cart myCart = Cart();

class FertilizerDetailPage extends StatefulWidget {
  const FertilizerDetailPage({super.key, required this.fertilizer});

  final Fertilizer fertilizer;

  @override
  State<FertilizerDetailPage> createState() => _FertilizerDetailPageState();
}

class _FertilizerDetailPageState extends State<FertilizerDetailPage> {
  bool showingMore = false;
  late TapGestureRecognizer readMoreGestureRecognizer;


  @override
  void initState() {
    readMoreGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        setState(() {
          showingMore = !showingMore;
        });
      };
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    readMoreGestureRecognizer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(IconlyBroken.bookmark)),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Container(
            height: 250,
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      widget.fertilizer.image,
                    ))),
          ),
          Text(
            widget.fertilizer.name,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Available in stock",
                style: TextStyle(
                    fontSize: 16, color: Theme.of(context).colorScheme.primary),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "₹${widget.fertilizer.price}",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    TextSpan(
                      text: "/${widget.fertilizer.unit}",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.star,
                size: 26,
                color: Colors.yellow.shade600,
              ),
              Text(
                "${widget.fertilizer.rating},(256)",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 16),
              ),
              Spacer(),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Description",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: showingMore
                      ? widget.fertilizer.description
                      : "${widget.fertilizer.description.substring(0, widget.fertilizer.description.length - 30)}....",
                ),
                TextSpan(
                  recognizer: readMoreGestureRecognizer,
                  text: showingMore ? " Read less" : " Read more",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Related Products",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 90,
            child: ListView.separated(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    height: 90,
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              Fertilizers[index].image,
                            ))),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(
                      width: 10,
                    ),
                itemCount: Fertilizers.length),
          ),
          SizedBox(
            height: 30,
          ),
          FilledButton.icon(
            onPressed: () {
              final cart =
              Provider.of<Cart>(context, listen: false);
              cart.addToCart(widget.fertilizer);

              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Center(child: Text('You added ${widget.fertilizer.name}')),
                  backgroundColor: Colors.green.shade900, // Adjust as needed
                ),
              );
            },
            icon: Icon(IconlyLight.bag2),
            label: Text("Add to Cart"),
          ),
        ],
      ),
    );
  }
}

class SeedDetailPage extends StatefulWidget {
  const SeedDetailPage({super.key, required this.seed});

  final Seed seed;

  @override
  State<SeedDetailPage> createState() => _SeedDetailPageState();
}

class _SeedDetailPageState extends State<SeedDetailPage> {
  bool showingMore = false;
  late TapGestureRecognizer readMoreGestureRecognizer;

  @override
  void initState() {
    readMoreGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        setState(() {
          showingMore = !showingMore;
        });
      };
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    readMoreGestureRecognizer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(IconlyBroken.bookmark)),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Container(
            height: 250,
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      widget.seed.image,
                    ))),
          ),
          Text(
            widget.seed.name,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Available in stock",
                style: TextStyle(
                    fontSize: 16, color: Theme.of(context).colorScheme.primary),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "₹${widget.seed.price}",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    TextSpan(
                      text: "/${widget.seed.unit}",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.star,
                size: 26,
                color: Colors.yellow.shade600,
              ),
              Text(
                "${widget.seed.rating},(256)",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 16),
              ),
              Spacer(),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "Description",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: showingMore
                      ? widget.seed.description
                      : "${widget.seed.description.substring(0, widget.seed.description.length - 30)}....",
                ),
                TextSpan(
                  recognizer: readMoreGestureRecognizer,
                  text: showingMore ? " Read less" : " Read more",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Related Products",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 90,
            child: ListView.separated(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    height: 90,
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              Seeds[index].image,
                            ))),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(
                      width: 10,
                    ),
                itemCount: Seeds.length),
          ),
          SizedBox(
            height: 30,
          ),
          FilledButton.icon(
            onPressed: () {
              final cart =
              Provider.of<Cart>(context, listen: false);
              cart.addToCart(widget.seed);

              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Center(child: Text('You added ${widget.seed.name}')),
                  backgroundColor: Colors.green.shade900, // Adjust as needed
                ),
              );
            },
            icon: Icon(IconlyLight.bag2),
            label: Text("Add to Cart"),
          ),
        ],
      ),
    );
  }
}

class MachineryDetailPage extends StatefulWidget {
  const MachineryDetailPage({super.key, required this.machinery});

  final Machinery machinery;

  @override
  State<MachineryDetailPage> createState() => _MachineryDetailPageState();
}

class _MachineryDetailPageState extends State<MachineryDetailPage> {
  bool showingMore = false;
  late TapGestureRecognizer readMoreGestureRecognizer;
  @override
  void initState() {
    readMoreGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        setState(() {
          showingMore = !showingMore;
        });
      };
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    readMoreGestureRecognizer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(IconlyBroken.bookmark)),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Container(
            height: 250,
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      widget.machinery.image,
                    ))),
          ),
          Text(
            widget.machinery.name,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Available in stock",
                style: TextStyle(
                    fontSize: 16, color: Theme.of(context).colorScheme.primary),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "₹${widget.machinery.price}",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    TextSpan(
                      text: "/${widget.machinery.unit}",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.star,
                size: 26,
                color: Colors.yellow.shade600,
              ),
              Text(
                "${widget.machinery.rating},(256)",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 16),
              ),
              Spacer(),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "Description",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: showingMore
                      ? widget.machinery.description
                      : "${widget.machinery.description.substring(0, widget.machinery.description.length - 30)}....",
                ),
                TextSpan(
                  recognizer: readMoreGestureRecognizer,
                  text: showingMore ? " Read less" : " Read more",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Related Products",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 90,
            child: ListView.separated(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    height: 90,
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              Machinerys[index].image,
                            ))),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(
                      width: 10,
                    ),
                itemCount: Seeds.length),
          ),
          SizedBox(
            height: 30,
          ),
          FilledButton.icon(
            onPressed: () {
              final cart =
              Provider.of<Cart>(context, listen: false);
              cart.addToCart(widget.machinery);

              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Center(child: Text('You added ${widget.machinery.name}')),
                  backgroundColor: Colors.green.shade900, // Adjust as needed
                ),
              );
            },
            icon: Icon(IconlyLight.bag2),
            label: Text("Add to Cart"),
          ),
        ],
      ),
    );
  }
}
