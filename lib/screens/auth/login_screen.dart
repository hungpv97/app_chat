import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../api/APIs.dart';
import '../../helper/dialogs.dart';
import '../../main.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }
//handles google login button click
  _handleGoogleBtnClick() {

    //showing progress bar
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then(
      (user) async {
        //hiding progress bar
        Navigator.pop(context);
        if (user != null) {
          log('/nUser: ${user.user}');
          if ((await APIs.userExists())) {
            Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomeScreen()));
          }else{
          await  APIs.createUser().then((value) {
              Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomeScreen()));
          });
          }
          
        }
      },
    );
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e');
      Dialogs.showSnackbar(context, 'error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("wwewwww"),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
              top: mq.height * .15,
              right: _isAnimate ? mq.width * .25 : -mq.width * .5,
              width: mq.width * .5,
              duration: Duration(seconds: 1),
              child: Image.asset('images/cute.png')),
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .1,
            width: mq.width * .8,
            height: mq.height * .07,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[300],
                  shape: StadiumBorder(),
                  elevation: 1),
              onPressed: () {
                _handleGoogleBtnClick();
              },
              icon: Image.asset(
                'images/google.png',
                height: mq.height * .04,
              ),
              label: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(text: 'LogIn with '),
                    TextSpan(
                      text: 'Google',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
