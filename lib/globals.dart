library my_prj.globals;
import 'package:flutter/material.dart';

//bool isStudent = true;

Color backgroundColor = Color(0xFFE5F5DB);
Color appBarColor = Color(0xFF468F59);
Color alterColor = Colors.brown[800];
Image appLogo = new Image.asset('pachaylogo/Pachay_palabra_bordeduro.png',
  fit: BoxFit.contain,
  height: 130,
);
AssetImage backgroundImage = AssetImage("pachaylogo/noLogoSuave.jpg");
BoxDecoration decoBackground = BoxDecoration(
  image: DecorationImage(
    image: backgroundImage,
    fit: BoxFit.cover,
  ),
);

//void updateIsStudent(bool x) {isStudent = x;}