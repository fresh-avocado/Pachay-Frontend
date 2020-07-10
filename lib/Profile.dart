import 'package:Pachay/RejectedPosts.dart' show RejectedPosts;
import 'package:Pachay/UnverifiedPosts.dart' show UnverifiedPosts;
import 'package:Pachay/VerifiedPosts.dart' show VerifiedPosts;
import 'package:Pachay/RecommendedMaterial.dart' show RecommendedMaterial;
import 'package:Pachay/FavoritePosts.dart' show FavoritePosts;
import 'package:flutter/material.dart';
import 'register.dart' show getSharedPref;
import 'package:Pachay/Post.dart' show Post;
import 'utilities.dart' show parsePosts;
import 'package:http/http.dart' as http;

// TODO: embellecer y mostrarle información relevante al usuario

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.title, this.role, this.backgroundColor, this.appBarColor, this.isModerator}) : super(key: key);
  final String title;
  final bool role;
  Color backgroundColor;
  Color appBarColor;
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
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        title: Text(widget.title,),
        backgroundColor: widget.appBarColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ),
      body: Center(
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
            if (!widget.role) Expanded(
              flex: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    child: Text("Posts Verificados"),
                    color: widget.appBarColor,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                VerifiedPosts(
                                  title: widget.title,
                                  backgroundColor: widget.backgroundColor,
                                  appBarColor: widget.appBarColor,
                                )
                        ),
                      );
                      print("Posts Verificados");
                    },
                  ),
                  RaisedButton(
                    child: Text("Posts No Verificados"),
                    color: widget.appBarColor,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UnverifiedPosts(
                                  title: widget.title,
                                  backgroundColor: widget.backgroundColor,
                                  appBarColor: widget.appBarColor,
                                )
                        ),
                      );
                      print("Posts No Verificados");
                    },
                  ),
                  RaisedButton(
                    child: Text("Posts Rechazados"),
                    color: widget.appBarColor,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RejectedPosts(
                                  title: widget.title,
                                  backgroundColor: widget.backgroundColor,
                                  appBarColor: widget.appBarColor,
                                )
                        ),
                      );
                      print("Posts Rechazados");
                    },
                  ),
                ],
              ),
            ),
            if (widget.role) Expanded(
              flex: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    child: Text("Material Recomendado"),
                    color: widget.appBarColor,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RecommendedMaterial(
                                  title: widget.title,
                                  backgroundColor: widget.backgroundColor,
                                  appBarColor: widget.appBarColor,
                                )
                        ),
                      );
                      print("Posts Verificados");
                    },
                  ),
                  RaisedButton(
                    child: Text("Posts Favoritos"),
                    color: widget.appBarColor,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FavoritePosts(
                                  title: widget.title,
                                  backgroundColor: widget.backgroundColor,
                                  appBarColor: widget.appBarColor,
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
    );
  }
}