import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Central_Page.dart';
import 'register.dart' show saveEmail, saveFirstName, saveLastName, saveRole, saveToken;

// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.

  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
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
      // TODO: mostrarle al usuario algo bonito que indique
      // que sí se pudo registrar
      // TODO: redirreccionarlo
      // al login o logearlo defrente
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      String authToken = responseBody['jwt'];
      print("PRINTING RESPONSE BODY");

      print(responseBody);

      saveFirstName(responseBody['firstName']);
      saveLastName(responseBody['lastName']);
      saveRole(responseBody['role']);

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
    // Build a Form widget using the _formKey created above.
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
                flex: 2,
                child: Container(
                  width: 150.0,
                  height: 50.0,
                  child: RaisedButton(
                    color: Colors.blueAccent,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        /// FIXME: mandar data al servidor acá
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
                              // TODO: guardar datos del user
                              saveEmail(_email);
                              Navigator.pop(context);
                              // TODO: renderizar de nuevo el main page
                            } else if (authToken == "e") {
                              // TODO: indicar al usuario que su email o contrasena son invalidos
                            } else {
                              // FIXME: decirle al usuario que ocurrio un error inesperado y que lo intente mas tarde
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
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  Future<String> _calculation = Future<String>.delayed(
    Duration(seconds: 2),
        () => 'Data Loaded',
  );

  var widthsize = 400.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
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
              child: Text('Inicia Sesión', textAlign: TextAlign.center,),
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
                        style: TextStyle(color: Colors.blue[900], fontSize: 50, fontFamily: 'Raleway'),
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
              child: Text('Inicia Sesión', textAlign: TextAlign.center,),
            )
          ],
        ),
      )
    );
  }
}
