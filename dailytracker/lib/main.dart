import 'package:dailytracker/Login/Login.dart';
import 'package:dailytracker/Register/Register.dart';
import 'package:dailytracker/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //configuracion para esperar el usuario a q se registre
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
              final user = snapshot.data;
              {
                ThemeData(
                  fontFamily: 'JosefinSans',
                );
              }
              if (user != null) {
                return const SplashScreen();
              } else {
                return const MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: '',
                  home: LoginPage(),
                );
              }
            }),
      ),
    );
  }
}
