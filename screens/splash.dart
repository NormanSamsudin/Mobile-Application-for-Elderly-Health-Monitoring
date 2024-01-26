import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:seniorconnect/config/colors.dart';

// loading screen when firebase is figuring out
class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      body:  Container(
        decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [darkCyan, tiffany_blue],
                  ),
                ),
        child: Center(
          child: Container(
            height: 200,
            width: 200,
            child: Lottie.asset('lib/assets/lottie/loading.json'))
        ),
      ),
    );
  }
}