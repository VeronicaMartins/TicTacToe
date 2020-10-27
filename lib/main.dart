import 'package:flutter/material.dart';
import 'package:tictactoe/core/constants.dart';
import 'package:tictactoe/core/theme_app.dart';
import 'pages/game_page.dart';
import 'package:custom_splash/custom_splash.dart';

void main() {
  runApp(MaterialApp(
    home: CustomSplash(
      imagePath: 'assets/Rick-And-Morty.png',
      backGroundColor: Colors.deepOrange,
      animationEffect: 'zoom-out',
      logoSize: 5000,
      home: MyApp(),
      duration: 2500,
      type: CustomSplashType.StaticDuration,
    ),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: GAME_TITLE,
      theme: themeApp,
      home: GamePage(),
    );
  }
}
