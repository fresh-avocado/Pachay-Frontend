import 'package:flutter/material.dart';
import 'register.dart';
import 'Topic_Page.dart';
import 'login.dart';
import 'New_Post.dart';
import 'Profile.dart';

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

  final Map<String, List<String>> topicsAndSubtopics = {
    "Matemática" : ["Ecuaciones", "Geometría"],
    "Física": ["MRU", "Leyes de Newton"],
    "Química": ["Estequiometría", "Ácidos y Bases"],
    "Biología": ["Células", "Genética Mendeliana"]
  };
  final List<String> courses = ["Matemática", "Física", "Química", "Biología"];
  final List<Icon> courseIcons = [Icon(Icons.all_inclusive), Icon(Icons.multiline_chart), Icon(Icons.device_hub), Icon(Icons.face)];
  //final List<Color> courseColor = <Color>[Colors.purple[400], Colors.blue[400], Colors.lightGreen[400], Colors.amber[400]];
  final List<int> hexcourseColor = <int>[0xFFFF4C2E, 0xFF17BFEB, 0xFFFF0CFF, 0xFF94EB17 ]; //lila, celeste. verdelima, amarillo

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

  _navigateAndDisplaySelection(BuildContext context, String title, String where) async {
    // a little bit of repeated code
    if (where == "login") {
      final didLogIn = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(title: title,)),
      );
      if (didLogIn) {
        render(true);
      }
    } else if (where == "register") {
      final didRegister = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterPage(title: title,)),
      );
      if (didRegister) {
        render(true);
      }
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
              height: 70,
              splashColor: Colors.orangeAccent[100],
              color: Colors.orange,
              elevation: 0.0,
              onPressed: () {
                if (widget.isLoggedIn) {
                  if (widget.role == false) { // perfil del profesor
                    print("El profesor quiere ver su perfil");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(title: "Perfil", role: widget.role,),
                        ),
                    );

                  } else if (widget.role == true) { // perfil del alumno
                    print("El alumno quiere ver su perfil");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(title: "Perfil", role: widget.role,),
                      ),
                    );
                  }
                } else {
                  _navigateAndDisplaySelection(context, widget.title, "login");
                }
              },
              child: Text(
                widget.isLoggedIn ? "Mi Perfil" : "Inicia Sesión",
                style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Raleway'),
              )
          ),
          FutureBuilder<String>(
            future: getButtonMessage(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              Widget homePage;
              var buttonColor = Colors.orange;
              if (widget.isLoggedIn) {
                buttonColor = Colors.orange;
              }
              if (snapshot.hasData) {
                homePage = MaterialButton(
                  height: 70,
                  minWidth: 50,
                  splashColor: Colors.orangeAccent[100],
                  color: buttonColor,
                  elevation: 0.0,
                  onPressed: () {
                      if (buttonColor == Colors.orange && widget.role == false) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewPostPage(title: widget.title, topicsAndSubtopics: topicsAndSubtopics)
                          ),
                        );
                      } else if (buttonColor == Colors.orange && widget.role == true) {
                        // TODO: mandar al usuario a una pagina que permite hacer búsquedas de contenido mediante keyword
                      }
                  },
                  child: Text(
                    snapshot.data,
                    style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Raleway'),
                  ),
                );
              } else {
                homePage = Text("");
              }
              return homePage;
            },
          ),
          MaterialButton(
            height: 70,
            minWidth: 50,
            splashColor: Colors.orangeAccent[100],
            color: Colors.orange,
            elevation: 0.0,
            onPressed: () {
              if (widget.isLoggedIn) {
                deleteAuthToken();
                saveRole("");
                saveLastName("");
                saveFirstName("");
                saveEmail("");
                saveUserId("");
                render(false);
              } else {
                _navigateAndDisplaySelection(context, widget.title, "register");
              }
            },
            child: Text(
              widget.isLoggedIn ? "Cerrar Sesión" : "Regístrate",
              style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Raleway'),
            ),
          ),

        ],
      ),

      body: Row(
        children: [
          Expanded(
            flex: 2,
            child:
              Text(''),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.all(30.0),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: topicsAndSubtopics.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    margin: EdgeInsets.all(15.0),
                    elevation: 5,
                    color: Color(hexcourseColor[index]),
                    child: InkWell(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: courseIcons[index],
                            title: Text(
                              courses[index],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            subtitle: Text("Subtítulo"),
                          ),
                          Text(""),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TopicPage(topic: courses[index], subtopics: topicsAndSubtopics[courses[index]], appBarColor: Color(hexcourseColor[index]))),
                        );
                      },
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
            Text(''),
          ),
        ],
      ),
    );
  }
}