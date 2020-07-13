import 'package:Pachay/ModeratorPage.dart';
import 'package:flutter/material.dart';
import 'register.dart';
import 'Topic_Page.dart';
import 'login.dart';
import 'New_Post.dart';
import 'Profile.dart';

// TODO: resolver TODO's
// TODO: mencionar que tambien funciona en iOS y Android
// TODO: mencionar que lo hicimos desde cero sin ningun template

/// IMPORTANTE:
// TODO: mostar el logo de pachay en la top-left corner en el Main Page.

class CentralPage extends StatefulWidget {

  String title;
  String rolee;
  bool isLoggedIn;
  bool role = true; // alumno
  bool isModerator;
  bool hasBeenCongratulated;

  CentralPage({Key key, this.title, this.isLoggedIn, this.rolee, this.isModerator, this.hasBeenCongratulated}) : super(key: key);

  @override
  _CentralPageState createState() => _CentralPageState();
}

class _CentralPageState extends State<CentralPage> {

  /// PACHAY'S BACKGROUND COLOR
  Color _backgroundColor = Color(0xFFE5F5DB);
  Color _appBarColor = Color(0xFF587647);
  Image appLogo = new Image.asset('pachaylogo/Pachay_palabra_bordeduro.png',
    fit: BoxFit.contain,
    height: 130,
  );

  final Map<String, List<String>> topicsAndSubtopics = {
    "Matemática": ["Ecuaciones", "Geometría"],
    "Física": ["MRU", "Leyes de Newton"],
    "Química": ["Estequiometría", "Ácidos y Bases"],
    "Biología": ["Células", "Genética Mendeliana"]
  };
  final List<String> courses = ["Matemática", "Física", "Química", "Biología"];
  final List<Icon> courseIcons = [
    Icon(Icons.all_inclusive),
    Icon(Icons.multiline_chart),
    Icon(Icons.device_hub),
    Icon(Icons.face)
  ];

  //final List<Color> courseColor = <Color>[Colors.purple[400], Colors.blue[400], Colors.lightGreen[400], Colors.amber[400]];
  final List<int> hexcourseColor = <int>[
    0xFFD13F37,
    0xFF63CAEC,
    0xFFC564D2,
    0xFFBEE131
  ]; //rojo, celeste, lila, verdelimon
  final Map<String, List<Icon>> subtopicIcons = {
    "Matemática": [Icon(Icons.add), Icon(IconData(58740))],
    "Física": [Icon(Icons.directions_car), Icon(Icons.compare_arrows)],
    "Química": [Icon(Icons.print), Icon(Icons.title)],
    "Biología": [Icon(Icons.announcement), Icon(Icons.android)]
  };

  void render(bool ak) {
    widget.isLoggedIn = ak;
    // profesor: role = 0
    getSharedPref("role").then( (value) {
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
  }

  Future<String> getButtonMessage() async {
    String role = await getSharedPref("role");
    String _isModerator = await getSharedPref("isModerator");
    /// String _isModerator = await getSharedPref("isModerator");
    if (role == "0") {
      widget.role = false;
      return "Crear Post";
    } else if (role == "1") {
      widget.role = true;
      if (_isModerator == "1") {
        widget.isModerator = true;
        return "Moderar Posts";
      } else {
        return "Buscar Post";
      }
    } else {
      return "";
    }
  }

  _navigateAndDisplaySelection(BuildContext context, String title, String where) async {
    // a little bit of repeated code
    if (where == "login") {
      final didLogIn = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(title: title, appBarColor: _appBarColor, backgroudColor: _backgroundColor, appLogo: appLogo,)),
      );
      if (didLogIn) {
        render(true);
      }
    } else if (where == "register") {
      final didRegister = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterPage(title: title, appBarColor: _appBarColor, backgroundColor: _backgroundColor, appLogo: appLogo,)),
      );
      if (didRegister) {
        render(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _backgroundColor,
        appBar: AppBar(
          backgroundColor: _appBarColor,
          title: appLogo,
          centerTitle: true,
          actions: <Widget>[
            // FIXME: si no esta loggeado se muestra un boton vacío
            MaterialButton(
                height: 70,
                splashColor: Colors.orangeAccent[100],
                color: Color(0xFF587647),
                elevation: 0.0,
                onPressed: () {
                  if (widget.isLoggedIn) {
                    // FIXME: repeated code
                    if (widget.role == false) { // perfil del profesor
                      print("El profesor quiere ver su perfil");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfilePage(title: "Perfil",
                                  role: widget.role,
                                  backgroundColor: _backgroundColor,
                                  appBarColor: _appBarColor),
                        ),
                      );
                    } else if (widget.role == true) { // perfil del alumno
                      print("El alumno quiere ver su perfil");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfilePage(title: "Perfil",
                                  role: widget.role,
                                  isModerator: widget.isModerator,
                                  backgroundColor: _backgroundColor,
                                  appBarColor: _appBarColor),
                        ),
                      );
                    }
                  } else {
                    _navigateAndDisplaySelection(
                        context, widget.title, "login");
                  }
                },
                child: Text(
                  widget.isLoggedIn ? "Mi Perfil" : "Inicia Sesión",
                  style: TextStyle(
                      color: Colors.white, fontSize: 15, fontFamily: 'Raleway'),
                )
            ),
            FutureBuilder<String>(
              future: getButtonMessage(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                Widget homePage;
                var buttonColor = _appBarColor;
                if (widget.isLoggedIn) {
                  buttonColor = _appBarColor;
                }
                if (snapshot.hasData && widget.isLoggedIn) {
                  homePage = MaterialButton(
                    height: 70,
                    minWidth: 50,
                    splashColor: Colors.orangeAccent[100],
                    color: buttonColor,
                    elevation: 0.0,
                    onPressed: () {
                      if (buttonColor == _appBarColor && widget.role == false) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  NewPostPage(
                                      title: widget.title,
                                      topicsAndSubtopics: topicsAndSubtopics,
                                      backgroundColor: _backgroundColor,
                                      appBarColor: _appBarColor,
                                  )
                          ),
                        );
                      } else
                      if (buttonColor == _appBarColor && widget.isModerator) {
                        // TODO: mandar al alumno a la pagina que muestra los posts que se tienen que moderar
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ModeratorPage(
                                      title: "Moderar",
                                      appBarColor: _appBarColor,
                                      backgroundColor: _backgroundColor
                                  )
                          ),
                        );
                      } else if (buttonColor == _appBarColor && widget.role == true) {
                        // TODO: mandar al usuario a una pagina que permite hacer búsquedas de contenido mediante keyword
                      }
                    },
                    child: Text(
                      snapshot.data,
                      style: TextStyle(color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Raleway'),
                    ),
                  );
                } else {
                  homePage = Container();
                }
                return homePage;
              },
            ),
            MaterialButton(
              height: 70,
              minWidth: 50,
              splashColor: Colors.orangeAccent[100],
              color: _appBarColor,
              elevation: 0.0,
              onPressed: () {
                if (widget.isLoggedIn) {
                  deleteAuthToken();
                  saveRole("");
                  saveLastName("");
                  saveFirstName("");
                  saveEmail("");
                  saveUserId("");
                  saveIsModerator("");
                  widget.isModerator = false;
                  render(false);
                  print("User logged out.");
                } else {
                  _navigateAndDisplaySelection(context, widget.title, "register");
                }
              },
              child: Text(
                widget.isLoggedIn ? "Cerrar Sesión" : "Regístrate",
                style: TextStyle  (
                    color: Colors.white, fontSize: 15, fontFamily: 'Raleway'),
              ),
            ),

          ],
        ),

        body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(' ')
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
                          Text(""),
                          ListTile(
                            leading: courseIcons[index],
                            title: Text(
                              courses[index],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios),
                          ),
                          Text("")
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TopicPage(topic: courses[index],
                                                                            subtopics: topicsAndSubtopics[courses[index]],
                                                                            appBarColor: Color(hexcourseColor[index]),
                                                                            subtopicIcons: subtopicIcons[courses[index]],
                                                                            backgroundColor: _backgroundColor)
                          ),
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
