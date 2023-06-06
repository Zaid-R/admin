import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'model/auth.dart';
import 'pages/registration_page.dart';
import 'widgets/bottomNavBar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
//Disable landscape (force portrait)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(ChangeNotifierProvider<Auth>(
    create: (_) => Auth(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  Map<int, Color> x = const {
    50: Color.fromRGBO(93, 63, 211, 0.1),
    100: Color.fromRGBO(93, 63, 211, 0.2),
    200: Color.fromRGBO(93, 63, 211, 0.3),
    300: Color.fromRGBO(93, 63, 211, 0.4),
    400: Color.fromRGBO(93, 63, 211, 0.5),
    500: Color.fromRGBO(93, 63, 211, 0.6),
    600: Color.fromRGBO(93, 63, 211, 0.7),
    700: Color.fromRGBO(93, 63, 211, 0.8),
    800: Color.fromRGBO(93, 63, 211, 0.9),
    900: Color.fromRGBO(93, 63, 211, 1),
  };

  @override
  Widget build(BuildContext context) {
    MaterialColor colorCustom = MaterialColor(0xFF880E4F, x);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin',
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          textTheme: const TextTheme(
              bodyMedium: TextStyle(
            color: Colors.black,
          )),
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  backgroundColor: MaterialStateProperty.all(
                       Colors.indigo[400]
                      )
                  )),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0))),
                  backgroundColor: MaterialStateProperty.all(
                       Colors.indigo
                      )))),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return BottomNavBar();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Colors.indigo,),
              ),
            );
          } else {
            return RegistrationPage();
          }
        },
      ),
    );
  }
}