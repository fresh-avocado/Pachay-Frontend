import 'register.dart';
import 'package:flutter/material.dart';
import 'Central_Page.dart';

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
      //TODO: check is has been congratulated
      //TODO: check if is moderator

      if (authToken == "") {
        return "PACHAY";
      } else if (role == "0") {
        role = "0";
        return "Bienvenido Profesor";
      } else if (role == "1") {
        role = "1";
        // TODO: mandar request al comienzo, para ver si el alumno ha sido ascendido a moderador
        // TODO: si el request dice que es moderador, entonces setear 'isModerator = true;'
        // TODO: ademas mostrar un mensaje de felicidades solo 1 vez (guardar un key-value)

        return "Bienvenido $firstName";
      } else {
        return "PACHAY";
      }
    }

    return MaterialApp(
      title: 'Log In - Pachay',
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