import 'package:flutter/material.dart';
import 'register.dart' show getSharedPref;
import 'package:Pachay/Post.dart' show PostList, Post;
import 'utilities.dart' show parsePosts;
import 'package:http/http.dart' as http show get;

// TODO: embellecer y mostrarle información relevante al usuario

class UnverifiedPosts extends StatefulWidget {
  UnverifiedPosts({Key key, this.title, this.backgroundColor, this.appBarColor}) : super(key: key);
  final String title;
  Color backgroundColor;
  Color appBarColor;

  @override
  UnverifiedPostsState createState() => UnverifiedPostsState();
}

class UnverifiedPostsState extends State<UnverifiedPosts> {

  Future<List<Post>> fetchPostsByAuthor() async {
    // TODO: get all unverified posts
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
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Posts No Verificados",
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
              child: FutureBuilder<List<Post>>(
                future: fetchPostsByAuthor(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return Padding(
                    padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/5, left: MediaQuery.of(context).size.width/5),
                    child: snapshot.hasData ? PostList(posts: snapshot.data, inTeacherProfilePage: true, context: context, canDelete: false,) : Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}