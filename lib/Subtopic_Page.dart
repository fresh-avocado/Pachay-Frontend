import 'package:flutter/material.dart';
import 'package:Pachay/Post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SubtopicPage extends StatefulWidget {
  SubtopicPage({Key key, this.topic, this.subtopic, this.appBarColor}) : super(key: key);
  final String topic;
  final String subtopic;
  final Color appBarColor;

  @override
  _SubtopicPageState createState() => _SubtopicPageState();
}

class _SubtopicPageState extends State<SubtopicPage>{

  List<Post> parsePosts(String responseBody) {
    print(responseBody);
    List<dynamic> jsonPostList = jsonDecode(responseBody) as List<dynamic>;
    List<Post> parsedPosts = List<Post>();
    jsonPostList.forEach((post) {
      print(post);
      parsedPosts.add(Post.fromJson(post as Map<String, dynamic>));
    });
    return parsedPosts;
  }

  Future<List<Post>> fetchPostsByTopicAndSubtopic() async {

    final http.Response response = await http.post(
      'http://localhost:8080/post/topic/subtopic',
      headers: <String, String>{
        "Content-Type": "application/json",
      },
      body: jsonEncode(<String, String>{
        "topic": widget.topic,
        "subtopic": widget.subtopic,
      }),
    );

    return parsePosts(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: widget.appBarColor,
            title: Text(widget.subtopic),
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
                future: fetchPostsByTopicAndSubtopic(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData ? PostList(posts: snapshot.data, appBarColor: widget.appBarColor, inTeacherProfilePage: false,) : Center(child: CircularProgressIndicator());
                },
              ),
            ),
            Expanded(flex: 1, child: Text(''),),
          ],
        )
    );
  }
}