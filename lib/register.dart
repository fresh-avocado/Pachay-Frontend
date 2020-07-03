import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'utilities.dart' show showAlertDialog;

class MyCustomForm extends StatefulWidget {
  MyCustomForm({Key key, this.userRole}): super(key: key);
  int userRole;

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

Future<void> saveFirstName(String what) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("firstName", what);
}

Future<void> saveLastName(String what) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("lastName", what);
}

Future<void> saveEmail(String what) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("email", what);
}

Future<void> saveToken(String what) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("authToken", what);
}

Future<void> deleteAuthToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("authToken", "");
}

Future<void> saveRole(String role) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("role", role);
}

Future<void> saveUserId(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("userId", id);
}

Future<String> getSharedPref(String what) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String retrieved = prefs.getString("$what");
  return retrieved;
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  bool verifymail(String mail) {
    bool haveat = false;
    bool havewords = false;
    bool havedot = false;
    bool impos = false;

    for (int i = 0 ; i < mail.length; i++){
      if (mail[i] == '@'){
        if (haveat) impos = true;
        else if (havewords) {
          haveat = true;
          havewords = false;
        }
      }
      else if (mail[i] == '.' && havewords && haveat){
        havedot = true;
        havewords = false;
      }
      else {
        havewords = true;
      }
    }
    return havewords && haveat && havedot && !impos;
  }

  bool verifyPassword(String pass){
    bool mayus = false;
    bool symb = false;
    bool num = false;
    if (pass.length < 8) return false;
    for (int i = 0 ; i < pass.length; i++) {
      if ((pass.codeUnitAt(i) ^ 0x30) <= 9){
        num = true;
      }
      else if(pass[i] == "." || pass[i] == "_" || pass[i] == "\$" || pass[i] == "@" || pass[i] == "!" || pass[i] == "#") {
        symb = true;
      }
      else if (isUppercase(pass[i])){
        mayus = true;
      }

    }
    return num && symb && mayus;
  }

  Future<String> registrarUsuario(String firstName, String lastName, String password, String email, String role) async {
    final http.Response response = await http.post(
      'http://localhost:8080/usuarios',
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'role': role
      }),
    );
    // TODO: save user id
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      String authToken = responseBody['jwt'];
      saveUserId(responseBody['userId']);
      print(responseBody);
      return authToken;
    } else if (response.statusCode == 400) {
      print('No se pudo registrar el usuario');
      return "";
    } else if (response.statusCode == 500) {
      print("Uexpected exception in backend.");
      print("");
      return "";
    } else {
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
                  controller: firstName,
                  maxLength: 50,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Nombres',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return '¿Como te llamas?';
                    }
                    /// TODO: validar nombres, que no contengan caracteres locos
                    return null;
                  },
                ),
              ),
              Divider(height: 20,),
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: lastName,
                  maxLength: 50,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Apellidos',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Dinos tu apellido porfavor';
                    }
                    /// TODO: validar apellidos, que no contengan caracteres locos
                    return null;
                  },
                ),
              ),
              Divider(height: 20,),
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
                      return 'Necesitamos tu correo para recordarte';
                    } else if (!verifymail(value)){
                      return "Esto no parece un correo electrónico";
                    }
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
                      return 'Recuerda que es importante tener una contraseña';
                    }
                    else if (!verifyPassword(value)){
                      return "Recuerda usar Mayusculas, simbolos, números y mínimo 8 caracteres";
                    }
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
                        String _firstName = firstName.text;
                        String _lastName = lastName.text;
                        String _password = password.text;
                        String _role = widget.userRole.toString();
                        print('Registrando a:\nFirst Name: $_firstName\nLast Name: $_lastName\nEmail: $_email\nPassword: $_password\nRole: $_role');
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Registrando al usuario')));
                        registrarUsuario(_firstName, _lastName, _password, _email, _role).then(
                          (authToken) {
                            if (authToken != "") {
                              print("User just registered!");
                              print("$authToken");
                              saveToken(authToken);
                              // guardar los datos del ususario
                              saveEmail(_email);
                              saveFirstName(_firstName);
                              saveLastName(_lastName);
                              saveRole(_role);
                              Navigator.pop(context, true); // regresar al main page
                            } else {
                              showAlertDialog(context, "No te pudimos registrar", "Inténtalo de nuevo más tarde.", false);
                              print("Error: no se pudo registrar al usuario.");
                            }
                          }
                        );
                      }
                    },
                    child: Text('Registrarme'),
                  ),
                ),
              ),
              Divider(height: 20,),
            ]
        )
    );
  }
}

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>{
  bool _isVisible = true;
  double widthsize = 400.0;

  final name = TextEditingController();
  final lastname = TextEditingController();
  final mail = TextEditingController();
  final password = TextEditingController();
  int userRole = 0;

  void dispose() {
    // Clean up the controller when the widget is disposed.
    name.dispose();
    lastname.dispose();
    mail.dispose();
    password.dispose();
    super.dispose();
  }

  void showReg() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

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
            child: Visibility(
              visible: !_isVisible,
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
                      children: [
                        Divider(height: 20,),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Regístrate",
                            style: TextStyle(color: Colors.blue[900], fontSize: 50, fontFamily: 'Raleway'),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: MyCustomForm(userRole: userRole,),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('', textAlign: TextAlign.center,),
                  ),
                ],
              ),
              replacement: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(padding: const EdgeInsets.only(top: 1),),
                  ),
                  Card(
                    color: Colors.white,
                    shadowColor: Colors.grey,
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        userRole = 0;
                        showReg();
                      },
                      child: Container(
                          width: 250,
                          height: 250,
                          child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                ),
                                Text('Soy Profesor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                ),
                                Icon(Icons.business_center, size: 150.0, color: Colors.grey,),
                              ]
                          )
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(padding: const EdgeInsets.only(top: 1),),
                  ),
                  Card(
                    color: Colors.white,
                    shadowColor: Colors.grey,
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        userRole = 1;
                        showReg();
                      },
                      child: Container(
                          width: 250,
                          height: 250,
                          child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                ),
                                Text('Soy Estudiante', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                ),
                                Icon(Icons.book, size: 150.0, color: Colors.grey,),
                              ]
                          )
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(padding: const EdgeInsets.only(top: 1),),
                  ),
                ],
              ),
            )
        ),
    );
  }
}