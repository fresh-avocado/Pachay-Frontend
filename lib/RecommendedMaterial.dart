import 'package:flutter/material.dart';
import 'register.dart' show getSharedPref;
import 'package:Pachay/Post.dart' show Post;
import 'utilities.dart' show parsePosts;
import 'package:http/http.dart' as http show get;
import 'globals.dart' as globals;

// TODO: embellecer y mostrarle información relevante al usuario

class RecommendedMaterial extends StatefulWidget {
  RecommendedMaterial({Key key, this.title, this.backgroundColor, this.appBarColor}) : super(key: key);
  final String title;
  Color backgroundColor;
  Color appBarColor;

  @override
  RecommendedMaterialState createState() => RecommendedMaterialState();
}

class RecommendedMaterialState extends State<RecommendedMaterial> {

  // TODO: hacer queries para:
  /// material que Pachay sugiere
  Future<List<Post>> fetchPostsByAuthor() async {
    final String userId = await getSharedPref("userId");
    final token = await getSharedPref("authToken");
    final response = await http.get("http://localhost:8080/post/author", headers: {"Authorization": "Bearer $token"});
    return parsePosts(response.body, userId);
  }

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
      body: Container(
        decoration: globals.decoBackground,
        child: Center(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "Material Recomendado por Pachay",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 40,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 30,
                child: Text(""),
              ),
            ],
          ),
        ),
      ),
    );
  }
}