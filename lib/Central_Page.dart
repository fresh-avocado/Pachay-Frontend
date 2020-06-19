import 'package:flutter/material.dart';

import 'register.dart';
import 'Topic_Page.dart';
import 'login.dart';
import 'New_Post.dart';
import 'Profile.dart';

// TODO: llamar setSate en CentralPage, cuando se llama a Navigator.pop en register.dart y en login.dart
// TODO: resolver TODO's

class CentralPage extends StatefulWidget {

  String title;
  String rolee;
  bool isLoggedIn;
  bool role = true; // alumno

  CentralPage({Key key, this.title, this.isLoggedIn, this.rolee}) : super(key: key);

  @override
  _CentralPageState createState() => _CentralPageState();
}

class _CentralPageState extends State<CentralPage> {

  final List<String> courses = <String>['Matemática', 'Física', 'Quimica', 'Biologia'];
  final List<Color> courseColor = <Color>[Colors.red, Colors.amber, Colors.blue, Colors.green];

  String getusername(){
    getSharedPref("firstName").then(
        (value){
          print(value);
          return value;
        }
    );
  }

  void render(bool ak) {
    widget.isLoggedIn = ak;

    // profesor: role = 0
    getSharedPref("role").then(
      (value) {
        if (value == "0") { // profesor
          widget.role = false;
          widget.title = "Bienvenido Profesor";
        } else if (value == "1") { // alumno
          widget.role = true;
          widget.title = "Bienvenido Alumno";
        } else {
          widget.title = "PACHAY";
        }
        setState(() {});
    });
    setState(() {});
  }

  Future<String> getButtonMessage() async {
    String role = await getSharedPref("role");
    if (role == "0") {
      widget.role = false;
      return "Crear Post";
    } else if (role == "1") {
      widget.role = true;
      return "Buscar Post";
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: <Widget>[
          MaterialButton(
              splashColor: Colors.orangeAccent[100],
              color: Colors.deepOrange,
              onPressed: () {
                if (widget.isLoggedIn) {
                  if (widget.role == false) { // perfil del profesor
                    // TODO: mandar al profesor a su perfil
                    print("El profesor quiere ver su perfil");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(title: widget.title, role: widget.role,),
                        ),
                    );

                  } else if (widget.role == true) { // perfil del alumno
                    // TODO: mandar al alumno a su perfil
                    print("El alumno quiere ver su perfil");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(title: widget.title, role: widget.role,),
                      ),
                    );
                  }
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage(title: widget.title,)),
                  );
                }
              },
              child: Text(
                widget.isLoggedIn ? "Mi Perfil" : "Inicia Sesión",
                style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Raleway'),
              )
          ),
          FutureBuilder<String>(
            future: getButtonMessage(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              Widget homePage;
              var buttonColor = Colors.orange;
              if (widget.isLoggedIn) {
                buttonColor = Colors.deepOrange;
              }
              if (snapshot.hasData) {
                homePage = MaterialButton(
                  height: 20,
                  minWidth: 50,
                  splashColor: Colors.orangeAccent[100],
                  color: buttonColor,
                  onPressed: () {
                    if (widget.isLoggedIn && widget.role == true) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewPostPage(title: widget.title,)
                        ),
                      );
                    } else if (widget.isLoggedIn && widget.role == false) {
                      // nothing for now
                    } else {
                      // disable button
                    }
                  },
                  child: Text(
                    snapshot.data,
                    style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Raleway'),
                  ),
                );
              } else {
                homePage = CircularProgressIndicator();
              }
              return homePage;
            },
          ),
          MaterialButton(
            height: 20,
            minWidth: 50,
            splashColor: Colors.orangeAccent[100],
            color: Colors.deepOrange,
            onPressed: () {
              if (widget.isLoggedIn) {
                deleteAuthToken();
                saveRole("");
                saveLastName("");
                saveFirstName("");
                saveEmail("");
                render(false);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegisterPage(title: widget.title,)
                  ),
                );
              }
            },
            child: Text(
              widget.isLoggedIn ? "Cerrar Sesión" : "Regístrate",
              style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Raleway'),
            ),
          ),

        ],
      ),

      body: Row(
        children: [
          Expanded(
            flex: 2,
            child:
//            ListView.separated(
//              itemBuilder: (_, idx) => Text('Item $idx', textAlign: TextAlign.center,),
//              separatorBuilder: (a, b) => Divider(),
//              itemCount: 100,
//            ),
              Text(''),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.all(30.0),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: courses.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        print(courses[index]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              TopicPage(topic: courses[index],)),
                        );
                      },
                      child: Container(
                        color: courseColor[index],
                        width: 300,
                        height: 100,
                        child: Center(
                          child: Text(courses[index], style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  );
                },
                scrollDirection: Axis.vertical,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child:
//            ListView.separated(
//              itemBuilder: (_, idx) => Text('Item $idx', textAlign: TextAlign.center,),
//              separatorBuilder: (a, b) => Divider(),
//              itemCount: 100,
//            ),
            Text(''),
          ),
        ],
      ),
    );
  }

}