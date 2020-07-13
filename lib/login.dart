import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'register.dart' show saveEmail, saveFirstName, saveLastName, saveRole, saveToken, saveUserId, saveIsModerator;
import 'utilities.dart' show showAlertDialog;

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  Future<String> loggearUsuario(String email, String password) async {
    final http.Response response = await http.post(
      'http://localhost:8080/authenticate',
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password
      }),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      String authToken = responseBody['jwt'];

      print(responseBody);

      saveFirstName(responseBody['firstName']);
      saveLastName(responseBody['lastName']);
      saveRole(responseBody['role']);
      // FIXME: corregir la linea de abajo
      // saveRole(responseBody['isModerator']);
      // FIXME: cambiar lo de abajo, solo estoy probando
      saveUserId(responseBody['userId']);

      return authToken;
    } else if (response.statusCode == 400) {
      print('Email o contraseña invalidas');
      return "e";
    } else {

      print("Unexpected error");
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: email,
                  maxLength: 50,
                  decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    labelText: 'Correo Electrónico',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Este campo es obligatorio.';
                    }
                    /// TODO: validar que es un mail correcto
                    return null;
                  },
                ),
              ),
              Divider(height: 20,),
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: password,
                  maxLength: 50,
                  obscureText: true,
                  decoration: InputDecoration(
                    icon: Icon(Icons.security),
                    labelText: 'Contraseña',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Este campo es obligatorio.';
                    }
                    /// TODO: validar que es una contraseña correcta
                    return null;
                  },
                ),
              ),
              Divider(height: 20,),
              Expanded(
                flex: 1,
                child: Container(
                  width: 150.0,
                  height: 50.0,
                  child: RaisedButton(
                    color: Colors.blueAccent,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        String _email = email.text;
                        String _password = password.text;
                        print('Iniciando sesión de:\nEmail: $_email\nPassword: $_password');
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Loggeando al usuario')));
                        loggearUsuario(_email, _password).then(
                          (authToken) {
                            if (authToken != "" && authToken != "e") {
                              print("User just logged in!");
                              print("$authToken");
                              saveToken(authToken);
                              saveEmail(_email);
                              Navigator.pop(context, true);
                            } else if (authToken == "e") {
                              showAlertDialog(context, "No se pudo iniciar sesión", "La contraseña y/o el correo es inválido.", false);
                            } else {
                              showAlertDialog(context, "Oops", "Ocurrió un error. Inténtelo de nuevo más tarde.", false);
                            }
                          }
                        );
                      }
                    },
                    child: Text('Iniciar Sesión'),
                  ),
                ),
              ),
              Divider(height: 20,),
            ]
        )
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.appBarColor, this.backgroudColor, this.appLogo}) : super(key: key);
  final Color appBarColor;
  final Color backgroudColor;
  final String title;
  final Image appLogo;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  var widthsize = 400.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroudColor,
      appBar: AppBar(
        title: widget.appLogo,
        centerTitle: true,
        backgroundColor: widget.appBarColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ),
      body: Center(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text('', textAlign: TextAlign.center,),
            ),
            Expanded(
              flex: 3,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Divider(height: 20,),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Iniciar Sesión",
                        style: TextStyle(color: Colors.brown[900], fontSize: 50, fontFamily: 'Raleway'),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: MyCustomForm(),
                    ),
                  ]
              ),
            ),
            Expanded(
              flex: 2,
              child: Text('', textAlign: TextAlign.center,),
            )
          ],
        ),
      )
    );
  }
}