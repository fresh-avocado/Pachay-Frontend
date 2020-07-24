import 'package:Pachay/register.dart' show getSharedPref;
import 'package:flutter/material.dart';
import 'package:Pachay/Post.dart' show Post, PostList;
import 'package:http/http.dart' as http show Response, post;
import 'dart:convert' show jsonDecode, jsonEncode;
import 'globals.dart' as globals;

class SubtopicPage extends StatefulWidget {
  SubtopicPage({Key key, this.subtopicImage, this.subtopic, this.appBarColor}) : super(key: key);
  final Image subtopicImage;
  final String subtopic;
  final Color appBarColor;
  String cachedUserId = "";
  String cachedToken = "";
  bool orderByRating = false;

  @override
  _SubtopicPageState createState() => _SubtopicPageState();
}

class _SubtopicPageState extends State<SubtopicPage>{

  List<Post> parsePosts(String responseBody, String userId) {
    print(responseBody);
    List<dynamic> jsonPostList = jsonDecode(responseBody) as List<dynamic>;
    List<Post> parsedPosts = List<Post>();
    jsonPostList.forEach((post) {
      print(post);
      parsedPosts.add(Post.fromJson(post as Map<String, dynamic>, userId));
    });
    return parsedPosts;
  }

  Future<List<Post>> fetchPostsByTopicAndSubtopic() async {
    if (widget.cachedUserId == "") {
      widget.cachedUserId = await getSharedPref("userId");
    }
    final http.Response response = await http.post(
      'http://localhost:8080/post/topic/subtopic',
      headers: <String, String>{
        "Content-Type": "application/json",
      },
      body: jsonEncode(<String, String>{
        "subtopic": widget.subtopic,
      }),
    );
    return parsePosts(response.body, widget.cachedUserId);
  }

  Future<List<Post>> fetchPostsByTopicAndSubtopicOrderedByRating() async {
    if (widget.cachedUserId == "") {
      widget.cachedUserId = await getSharedPref("userId");
    }
    final http.Response response = await http.post(
      'http://localhost:8080/post/topic/subtopic/rating',
      headers: <String, String>{
        "Content-Type": "application/json",
      },
      body: jsonEncode(<String, String>{
        "subtopic": widget.subtopic,
      }),
    );
    return parsePosts(response.body, widget.cachedUserId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globals.backgroundColor,
        appBar: AppBar(
            backgroundColor: widget.appBarColor,
            actions: [
              MaterialButton(
                color: widget.appBarColor,
                child: Text(!widget.orderByRating ? "Ordenar por Rating" : "Ordenar por Fecha"),
                onPressed: () {
                  if (!widget.orderByRating) {
                    widget.orderByRating = true;
                  } else {
                    widget.orderByRating = false;
                  }
                  setState(() {});
                },
              )
            ],
            title: widget.subtopicImage,
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
              children: [
                //Expanded(flex: 1, child: Text(''),),
                Expanded(
                  flex: 4,
                  child: FutureBuilder<List<Post>>(
                    future: !widget.orderByRating ? fetchPostsByTopicAndSubtopic() : fetchPostsByTopicAndSubtopicOrderedByRating(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      return snapshot.hasData ? Padding(
                        padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/5, left: MediaQuery.of(context).size.width/5),
                        child: PostList(posts: snapshot.data, appBarColor: widget.appBarColor, inTeacherProfilePage: false, canDelete: false,),
                      ) : Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
                //Expanded(flex: 1, child: Text(''),),
              ],
            ),
          ),
        )
    );
  }
}