// audio_guidance_splash.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bondtime/screens/audio_guidance_screen.dart';

class AudioGuidanceSplashScreen extends StatefulWidget {
  @override
  _AudioGuidanceSplashScreenState createState() => _AudioGuidanceSplashScreenState();
}

class _AudioGuidanceSplashScreenState extends State<AudioGuidanceSplashScreen> {
  String displayText = 'Waking up your assistance...';
  bool showText = true;
  double fontSize = 24.0;
  double opacity = 1.0;

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 1), () {
      setState(() {
        displayText = 'Get ready';
        fontSize = 24.0;
        opacity = 1.0;
      });

      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          fontSize = 60.0;
          opacity = 0.0;
        });

        Future.delayed(Duration(seconds: 1), () {
          // Navigate to Audio Guidance Screen after the animation completes
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AudioGuidanceScreen()),
          );
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: TweenAnimationBuilder(
          duration: Duration(seconds: 1),
          tween: Tween<double>(begin: fontSize, end: fontSize),
          builder: (context, dynamic size, child) {
            return AnimatedOpacity(
              duration: Duration(seconds: 1),
              opacity: opacity,
              child: Text(
                displayText,
                style: TextStyle(
                  fontSize: size,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD8C3B4),
                  fontFamily: 'Trueno',
                ),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
    );
  }
}
