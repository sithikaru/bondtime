// main.dart

import 'package:flutter/material.dart';
import 'screens/audio_guidance_splash.dart';
import 'screens/audio_guidance_screen.dart';

void main() {
  runApp(BondTimeApp());
}

class BondTimeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BondTime',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Trueno', // Set Trueno as the default font family
      ),
      home: AudioGuidanceSplashScreen(),
    );
  }
}
