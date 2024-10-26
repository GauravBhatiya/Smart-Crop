import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:smart_crop/models/fertilizer_product.dart';
import 'package:pdf/widgets.dart' as pw;

class CartPage extends StatefulWidget {
  CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Razorpay? _razorpay;
  late Cart cart;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    cart = Provider.of<Cart>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay!.clear();
  }

  void _startPayment(double discountPrice) async {
    var options = {
      'key': 'rzp_test_cfTVsUAB5c2IBw',
      'amount': '${cart.getTotalPrice() * 100}',
      'name': 'Smart Crop',
      'description': 'Payment for a product',
      'prefill': {'contact': '7984327489', 'email': 'test@example.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print('Payment Successful: ${response.paymentId}');

    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final User? user = _auth.currentUser;

      if (user != null) {
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        final String firstName = userDoc['firstName'] ?? 'Guest';
        final String userEmail = userDoc['email'];

        final pdf = pw.Document();

        pdf.addPage(
          pw.Page(build: (pw.Context context) {
            return pw.Stack(
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Header(
                      text: '$firstName\'s Invoice'.toUpperCase(),
                      textStyle: pw.TextStyle(
                        fontSize: 35,
                        color: PdfColor.fromHex(
                            '#000000'),
                      ),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Table(
                      border: pw.TableBorder.all(
                          color: PdfColor.fromHex('#000000'), width: 2),
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Container(
                              padding: const pw.EdgeInsets.all(20),
                              child: pw.Text(
                                'INVOICE FOR PAYMENT',
                                style: pw.Theme.of(context).header4.copyWith(
                                  color: PdfColor.fromHex('#000000'),
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        ...cart.items.map(
                              (e) => pw.TableRow(
                            children: [
                              pw.Expanded(
                                child: pw.Container(
                                  padding: const pw.EdgeInsets.all(10),
                                  color: const PdfColor.fromInt(0xFFF0F0F0),
                                  child: pw.Text(
                                    e.itemName,
                                    textAlign: pw.TextAlign.left,
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                flex: 2,
                              ),
                              pw.Expanded(
                                child: pw.Container(
                                  padding: const pw.EdgeInsets.all(10),
                                  color: const PdfColor.fromInt(
                                      0xFFF0F0F0),
                                  child: pw.Text(
                                    '${e.itemPrice.toString()}',
                                    textAlign: pw.TextAlign.right,
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                flex: 1,
                              ),
                            ],
                          ),
                        ),
                        pw.TableRow(
                          children: [
                            pw.Container(
                              padding: const pw.EdgeInsets.all(10),
                              child: pw.Text(
                                'TAX',
                                textAlign: pw.TextAlign.right,
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.all(10),
                              child: pw.Text(
                                '${(cart.getTotalPrice() * 0.1).toStringAsFixed(2)}',
                                textAlign: pw.TextAlign.right,
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                            pw.TableRow(
                              children: [
                                pw.Container(
                                  padding: const pw.EdgeInsets.all(10),
                                  child: pw.Text(
                                    'DISCOUNT',
                                    textAlign: pw.TextAlign.right,
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  padding: const pw.EdgeInsets.all(10),
                                  child: pw.Text(
                                    '${(cart.getTotalPrice()).toStringAsFixed(2)}', // Applying 50% discount
                                    textAlign: pw.TextAlign.right,
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 20, // Set your desired text color
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        pw.TableRow(
                          children: [
                            pw.Container(
                              padding: const pw.EdgeInsets.all(10),
                              child: pw.Text(
                                'TOTAL',
                                textAlign: pw.TextAlign.right,
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.all(10),
                              child: pw.Text(
                                '${cart.getTotalPrice()}',
                                textAlign: pw.TextAlign.right,
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 20,
                                  color: PdfColor.fromHex(
                                      '#f44336'), // Set your desired text color
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.Footer(
                      margin: const pw.EdgeInsets.only(top: 150),
                      title: pw.Text(
                        '     THANK YOU FOR YOUR PURCHASE',
                        style: pw.TextStyle(
                          fontSize: 16,
                          color: PdfColor.fromHex(
                              '#000000'), // Set your desired text color
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        );

        final directory = await getTemporaryDirectory();

        // Save the PDF to a file
        final file = File('${directory.path}/invoice.pdf');
        final Uint8List pdfBytes = await pdf.save();
        final List<int> bytes = pdfBytes.toList();

        await file.writeAsBytes(bytes);

        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Invoice Generated'),
              content: const Text('Invoice has been generated successfully.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    try {
                      final smtpServer =
                      gmail('janroy078@gmail.com', 'owyj kdkx ifxm ogng');
                      final message = Message()
                        ..from =
                        const Address('janroy078@gmail.com', 'SMART CROP')
                        ..recipients.add(userEmail)
                        ..subject = 'Invoice for your purchase'
                        ..text =
                            'Please find attached the invoice for your purchase.'
                        ..attachments.add(FileAttachment(
                            File('${directory.path}/invoice.pdf')));

                      final sendReports = await send(message, smtpServer);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Email sent successfully!')),
                      );
                      Navigator.of(context).pop();
                    } catch (error) {
                      print(error);
                    }
                  },
                  child: const Text('Send to Email'),
                ),
                TextButton(
                  onPressed: () {
                    OpenFile.open(file.path);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('PDF downloaded successfully!')),
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Download'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print(error);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment Error: ${response.code} - ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet: ${response.walletName}');
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: cart.items.isEmpty
                ? const Center(child: Text('Your cart is empty',style: TextStyle(fontSize: 15),))
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return Dismissible(
                    key: Key(item.itemName),
                    onDismissed: (direction) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Confirm Removal"),
                            content: Text("Are you sure you want to remove ${item.itemName}?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                  setState(() {
                                    cart.removeFromCart(item);
                                  });
                                },
                                child: Text("Yes"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                                child: Text("No"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    background: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                      child: Container(
                        color: Colors.red,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 34.0,
                        ),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        elevation: 2,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 6.0), // Add horizontal padding to the content
                            leading: SizedBox(
                              width: 100,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
                                  child: Image.asset(
                                    item.itemImage,
                                    fit: BoxFit.cover, // Ensure the image covers the entire space
                                  ),
                                ),
                              ),
                            ),
                            title: SizedBox(
                              width: 20,
                              child: Text(
                                item.itemName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis, // Add ellipsis if the text overflows
                              ),
                            ),
                            subtitle: Text('Price: ₹${item.itemPrice}'),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.green.shade800,
              ),
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Price',
                        style: TextStyle(fontSize: 17,color: Colors.white,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '₹${cart.getTotalPrice()}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      double totalprice = cart.getTotalPrice();
                      if(totalprice >= 5000) {
                        double discountPrice = totalprice * 0.5;
                        _startPayment(discountPrice);
                        Fluttertoast.showToast(msg: "Congratulation! you received a 50% discount.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          fontSize: 16.0,
                        );
                      }else {
                      _startPayment(totalprice);
                      };
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const Row(
                        children: [
                          Text(
                            'Buy Now',
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
