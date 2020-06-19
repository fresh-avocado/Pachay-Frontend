import 'register.dart';
import 'package:flutter/material.dart';

import 'Central_Page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  String _role = null;

  @override
  Widget build(BuildContext context) {

    Future<String> getProperMessage() async {
      String authToken = await getSharedPref("authToken");
      String role = await getSharedPref("role");
      if (authToken == "") {
        return "Pachay";
      } else if (role == "0") {
        role = "0";
        return "Bienvenido Profesor";
      } else if (role == "1") {
        role = "1";
        return "Bienvenido Alumno";
      } else {
        return "Pachay";
      }
    }

    return MaterialApp(
      title: 'Log In - Pachay',
      theme: new ThemeData(
          primarySwatch: Colors.orange,
          primaryTextTheme: TextTheme(
              headline6: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 60,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic
              )
          ),
          scaffoldBackgroundColor: Colors.orangeAccent[100],
      ),
      home: FutureBuilder<String>(
      future: getProperMessage(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        Widget homePage;
        if (snapshot.hasData) {
          homePage = CentralPage(title: snapshot.data, isLoggedIn: (snapshot.data != "PACHAY") ? true : false, rolee: _role,);

        } else {
//          homePage = CentralPage(title: "PACHAY", isLoggedIn: false);
          homePage = CircularProgressIndicator();
        }
        return homePage;
      },
    ),
    );
  }
}


