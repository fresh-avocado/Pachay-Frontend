import 'package:flutter/material.dart';
import 'register.dart' show getSharedPref;
import 'package:Pachay/Post.dart';
import 'dart:convert' show jsonDecode;
import 'package:http/http.dart' as http;

// TODO: embellecer y mostrarle información relevante al usuario

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.title, this.role, this.backgroundColor, this.appBarColor}) : super(key: key);
  final String title;
  final bool role;
  Color backgroundColor;
  Color appBarColor;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  List<Post> parsePosts(String responseBody, String userId) {
    List<dynamic> jsonPostList = jsonDecode(responseBody) as List<dynamic>;
    print(jsonPostList);
    List<Post> parsedPosts = List<Post>();
    jsonPostList.forEach((post) {
      print(post);
      parsedPosts.add(Post.fromJson(post as Map<String, dynamic>, userId));
    });
    return parsedPosts;
  }

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
      // nunca deber'ia llegar a este else KERNEL_PANIC()
      return "no se puedo obtener el firstName del key-value pair";
    }
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
            if (widget.role) Expanded(
              flex: 2,
              child: Text("Videos de YouTube que Pachay recomienda.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),),
            ),
            if (!widget.role) Expanded(
              flex: 3,
              child: Expanded(
                flex: 4,
                child: FutureBuilder<List<Post>>(
                  future: fetchPostsByAuthor(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return Padding(
                      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/5, left: MediaQuery.of(context).size.width/5),
                      child: snapshot.hasData ? PostList(posts: snapshot.data, inTeacherProfilePage: true, context: context,) : Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}