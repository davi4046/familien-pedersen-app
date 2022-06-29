import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/auth_page.dart';
import 'pages/home_page.dart';
import 'utils.dart';
import 'package:flutter/material.dart';



Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();
final utilsInstance = Utils();

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: utilsInstance.messengerKey,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Familien Pedersen App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const AuthPage();
          }
        }
      )
    );
  }
}