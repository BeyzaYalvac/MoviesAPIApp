import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'applicatonMainPage.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      animationDuration: Duration(seconds: 2 ),
      duration: 5660,
      splashIconSize: 400,
      backgroundColor: const Color(0xff000000),
      splash: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            
            Expanded( 
              child: LottieBuilder.network(
                  "https://lottie.host/0c9733da-40d3-47ef-b62f-f1f181c90949/NNrwqhYNkC.json"),
            ),
            Text("Movie It",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 34),)
          ],
        ),
      ),
      nextScreen: MainPage(),
    );
  }
}
