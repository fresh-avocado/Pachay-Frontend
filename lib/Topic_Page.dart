import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:Pachay/Post.dart';
//import 'package:Pachay/Subtopic_Page.dart' show SubtopicPage; en breves lo necesitaremos

class TopicPage extends StatefulWidget {
  TopicPage({Key key, this.topic, this.appBarColor}) : super(key: key);
  final String topic;
  final Color appBarColor;

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {

  List<Post> parsePosts(String responseBody) {
    List<dynamic> jsonPostList = jsonDecode(responseBody) as List<dynamic>;
    print(jsonPostList);
    List<Post> parsedPosts = List<Post>();
    jsonPostList.forEach((post) {
      print(post);
      parsedPosts.add(Post.fromJson(post as Map<String, dynamic>));
    });
    return parsedPosts;
  }

  Future<List<Post>> fetchPosts() async {
    final response = await http.get("http://localhost:8080/post");
    return parsePosts(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: widget.appBarColor,
            title: Text(widget.topic),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            )
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: Text(''),),
            Expanded(
              flex: 4,
              child: FutureBuilder<List<Post>>(
                future: fetchPosts(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData ? PostList(posts: snapshot.data, appBarColor: widget.appBarColor) : Center(child: CircularProgressIndicator());
                },
              ),
            ),
            Expanded(flex: 1, child: Text(''),),
          ],
        )
    );
  }
}

