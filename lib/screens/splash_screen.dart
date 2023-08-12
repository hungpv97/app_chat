import 'package:app_chat/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // full-screen
    Future.delayed(Duration(milliseconds: 1000), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));


        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginScreen()));
      
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      //app bar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Login we Chat',
        ),
      ),
      body: Stack(
        children: [
          Positioned(
              top: mq.height * .15,
              right: mq.width * .25,
              width: mq.width * .5,
              child: Image.asset('images/cute.png')),
          Positioned(
              bottom: mq.height * .15,
              width: mq.width,
              child: Text(
                'made in vietnam with ❤️',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              )),
        ],
      ),
    );
  }
}
