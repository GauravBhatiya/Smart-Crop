import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:smart_crop/firebase_options.dart';
import 'package:smart_crop/models/fertilizer_product.dart';
import 'package:smart_crop/welcome_page.dart';

import 'Disease/indentifying_screen/identifying_screen.dart';
import 'Home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Cart(),
      child: MaterialApp(
        title: 'Smart Crop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
          textTheme: GoogleFonts.mulishTextTheme(),
        ),
        home: const Welcomepage(),
        onGenerateRoute: (settings) {
          final args = settings.arguments;
          switch (settings.name) {
            case '/':
              return MaterialPageRoute<void>(
                builder: (BuildContext context) => const Homepage(),
              );
            case IdentifyingScreen.routeName:
              if (args is XFile) {
                return MaterialPageRoute<void>(
                  builder: (BuildContext context) => IdentifyingScreen(
                    image: args,
                  ),
                );
              }
              break;
          }
          return null;
        },
      ),
    );
  }
}
