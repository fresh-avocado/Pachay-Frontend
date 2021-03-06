import 'package:flutter/material.dart';
import 'register.dart' show getSharedPref;
import 'package:Pachay/Post.dart' show Post, PostList;
import 'utilities.dart' show parsePosts;
import 'package:http/http.dart' as http show get;
import 'globals.dart' as globals;

// TODO: embellecer y mostrarle información relevante al usuario

class VerifiedPosts extends StatefulWidget {
  VerifiedPosts({Key key, this.title, @required this.inModeratorView}) : super(key: key);
  final String title;
  final bool inModeratorView;

  @override
  VerifiedPostsState createState() => VerifiedPostsState();
}

class VerifiedPostsState extends State<VerifiedPosts> {

  Future<List<Post>> fetchPostsByAuthor() async {
    final String userId = await getSharedPref("userId");
    final token = await getSharedPref("authToken");
    final response = await http.get("http://localhost:8080/post/author", headers: {"Authorization": "Bearer $token"});
    return parsePosts(response.body, userId);
  }

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
                flex: 30,
                child: FutureBuilder<List<Post>>(
                  future: fetchPostsByAuthor(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return Padding(
                      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/5, left: MediaQuery.of(context).size.width/5),
                      child: snapshot.hasData ? PostList(
                        posts: snapshot.data,
                        inTeacherProfilePage: true,
                        context: context,
                        canDelete: true,
                        inModeradorProfilePage: widget.inModeratorView,
                        appBarColor: globals.appBarColor,

                      ) : Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}