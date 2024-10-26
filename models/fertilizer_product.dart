import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class CartItem {
  String get itemName;
  String get itemImage;
  double get itemPrice;
}

class Fertilizer implements CartItem {
  final String name;
  final String description;
  final String image;
  final double price;
  final String unit;
  final double rating;

  Fertilizer({
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.rating,
    required this.unit,
  });

  @override
  String get itemName => name;

  @override
  String get itemImage => image;

  @override
  double get itemPrice => price;
}



class Seed implements CartItem {
  final String name;
  final String description;
  final String image;
  final double price;
  final String unit;
  final double rating;

  Seed({
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.rating,
    required this.unit,
  });

  @override
  String get itemName => name;

  @override
  String get itemImage => image;

  @override
  double get itemPrice => price;
}



class Machinery implements CartItem {
  final String name;
  final String description;
  final String image;
  final double price;
  final String unit;
  final double rating;

  Machinery({
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.rating,
    required this.unit,
  });

  @override
  String get itemName => name;

  @override
  String get itemImage => image;

  @override
  double get itemPrice => price;
}



class Cart extends ChangeNotifier{

  List<CartItem> items = [];
  final CollectionReference _cartCollection =
  FirebaseFirestore.instance.collection('cart_items');

  void addToCart(CartItem item) async {
    items.add(item);
    notifyListeners();

    try {
      await _cartCollection.add({
        'itemName': item.itemName,
        'itemPrice': item.itemPrice,
      });
      print("Item added to cart: ${item.itemName}");
    } catch (error) {
      print("Failed to add item: $error");
    }
  }

  void removeFromCart(CartItem item) async {
    items.remove(item);
    notifyListeners();

    try {
      QuerySnapshot querySnapshot = await _cartCollection
          .where('itemName', isEqualTo: item.itemName)
          .limit(1)
          .get();
      querySnapshot.docs.forEach((doc) async {
        await doc.reference.delete();
      });
    } catch (error) {
      print("Failed to remove item: $error");
    }
  }

  double getTotalPrice() {
    double totalPrice = 0.0;
    for (var item in items) {
      totalPrice += item.itemPrice ;
    }
    if (totalPrice > 5000) { // Check if the total price is 5000 or more
      totalPrice *= 0.5; // Apply 50% discount
    }
    return  totalPrice;
  }
}



class Categories {
  final String image;
  final String name;

  const Categories(
      {
      required this.image,
        required this.name,
     });
}