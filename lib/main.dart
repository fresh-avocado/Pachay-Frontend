import 'register.dart' show getSharedPref;
import 'package:flutter/material.dart';
import 'Central_Page.dart' show CentralPage;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  String _role = null;
  bool isModerator = false;
  bool hasBeenCongratulated = false;

  @override
  Widget build(BuildContext context) {

    Future<String> getProperMessage() async {
      String authToken = await getSharedPref("authToken");
      String role = await getSharedPref("role");
      String firstName = await getSharedPref("firstName");
      String _isModerator = await getSharedPref("isModerator");
      if (authToken == "") {
        return "PACHAY";
      } else if (role == "0") {
        role = "0";
        return "Bienvenido Profesor";
      } else if (role == "1") {
        role = "1";
        if (_isModerator == "0") {

        } else if (_isModerator == "1") {
          isModerator = true;
        } else {

        }

        return "Bienvenido $firstName";
      } else {
        return "PACHAY";
      }
    }

    return MaterialApp(
      title: 'Pachay',
      theme: new ThemeData(
          primarySwatch: Colors.orange,
          primaryTextTheme: TextTheme(
              headline6: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 50,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
              )
          ),
          scaffoldBackgroundColor: Colors.orangeAccent[100],
      ),
      home: FutureBuilder<String>(
        future: getProperMessage(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          Widget homePage;
          if (snapshot.hasData) {
            homePage = CentralPage(title: snapshot.data, isLoggedIn: (snapshot.data != "PACHAY") ? true : false, rolee: _role, isModerator: isModerator, hasBeenCongratulated: hasBeenCongratulated);

          } else {
            homePage = CircularProgressIndicator();
          }
          return homePage;
        },
      ),
    );
  }
}