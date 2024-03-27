import 'package:dailytracker/Register/Register.dart';
import 'package:flutter/material.dart';

import 'Login/Login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.10,
                left: 10,
              ),
              child: Center(
                child: Image.asset(
                  'assets/Iconos/ic_launcher.png',
                  height: MediaQuery.of(context).size.height * 0.20,
                  width: MediaQuery.of(context).size.width * 0.35,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 400),
            const CircularProgressIndicator(
              strokeWidth: 5,
              valueColor: AlwaysStoppedAnimation<Color>(Color(
                  0xFFA0CE5E)), // Cambia el color del CircularProgressIndicator
            ),
          ],
        ),
      ),
    );
  }
}
