import 'package:Pachay/UnverifiedPosts.dart' show UnverifiedPosts;
import 'package:Pachay/FavoritePosts.dart' show FavoritePosts;
import 'package:Pachay/VerifiedPosts.dart';
import 'package:flutter/material.dart';
import 'register.dart' show getSharedPref;
import 'package:Pachay/Post.dart' show Post;
import 'utilities.dart' show parsePosts;
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;

// TODO: embellecer y mostrarle información relevante al usuario

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.title, this.role, this.isModerator}) : super(key: key);
  final String title;
  final bool role;
  final bool isModerator;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  // TODO: hacer queries para: (hacer estos queries en su respectiva página)
  /// posts verificados
  /// posts no verificados
  /// posts rechazados
  Future<List<Post>> fetchPostsByAuthor() async {
    final String userId = await getSharedPref("userId");
    final token = await getSharedPref("authToken");
    final response = await http.get("http://localhost:8080/post/author", headers: {"Authorization": "Bearer $token"});
    return parsePosts(response.body, userId);
  }

  Future<String> getNames() async {
    String firstName = await getSharedPref("firstName");
    String lastName = await getSharedPref("lastName");
    if (firstName != null) {
      return "$firstName $lastName";
    } else {
      // nunca deberia llegar a este else KERNEL_PANIC()
      return "no se puedo obtener el firstName del key-value pair";
    }
  }

  // TODO: si es moderador mostrar los posts que tienen que ser validados!!!!
  // TODO: al ser validados o rechazados, mandar un request al server para que los marque como aceptados o rechazados

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globals.backgroundColor,
      appBar: AppBar(
        title: Text(widget.title,),
        backgroundColor: globals.appBarColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ),
      body: Container(
        decoration: globals.decoBackground,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: FutureBuilder<String>(
                  future: getNames(),
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    Widget homePage;
                    if (snapshot.hasData) {
                      homePage = Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          widget.role == false ? "Profesor(a) ${snapshot.data}" : "Alumno ${snapshot.data}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 40,
                          ),
                        ),
                      );
                    } else {
                      homePage = CircularProgressIndicator();
                    }
                    return homePage;
                  },
                ),
              ),
              /// Vista del profesor
              if (!widget.role) Expanded(
                flex: 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                      child: Text("Posts No Verificados"),
                      color: globals.appBarColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UnverifiedPosts(
                                    title: "Posts No Verificados",
                                    inModeratorView: false,
                                  )
                          ),
                        );
                        print("Posts No Verificados");
                      },
                    ),
                  ],
                ),
              ),
              if (!widget.role) Expanded(
                flex: 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                      child: Text("Posts Verificados"),
                      color: globals.appBarColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  VerifiedPosts(
                                    title: "Posts Verificados",
                                    inModeratorView: false,
                                  )
                          ),
                        );
                        print("Posts No Verificados");
                      },
                    ),
                  ],
                ),
              ),
              /// Vista del Alumno que no es moderador
              if (widget.role) Expanded(
                flex: 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                      child: Text("Posts Favoritos"),
                      color: globals.appBarColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FavoritePosts(
                                    title: widget.title,
                                    backgroundColor: globals.backgroundColor,
                                    appBarColor: globals.appBarColor,
                                  )
                          ),
                        );
                        print("Posts Favoritos");
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}