import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timemate/ViewModel/TaskViewModel.dart';
import 'package:timemate/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => TaskViewModel(),
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TaskMate',
          home: SplashScreen(),
        ));
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Image.asset(
            'assets/aasd.png',
            width: screenWidth,
            height: screenWidth,
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: CircularProgressIndicator(
              strokeWidth: 5.0,
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 241, 0, 209)),
            ),
          ),
        ],
      ),
    );
  }
}
