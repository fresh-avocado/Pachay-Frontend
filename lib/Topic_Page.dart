import 'dart:convert';

import 'package:flutter/material.dart';
import 'Subtopic_Page.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class Post {
  final String title;
  final String desc;
  final String author;
  final String datePublished;
  final int rating;
  final int ratingCount;
  final List<String> youtubeLinks;

  Post({Key key, this.title, this.desc, this.author, this.datePublished, this.rating, this.ratingCount, this.youtubeLinks});

  factory Post.fromJson(Map<String, dynamic> body) {
    String author = "${body['author']['firstName']} ${body['author']['lastName']}";
    return Post(
      title: body['title'],
      desc: body['description'],
      author:  author,
      datePublished: body['date'],
      rating: body['rating'],
      ratingCount: body['ratingCount'],
      youtubeLinks: body['videos']
    );
  }

}

class TopicPage extends StatefulWidget {
  TopicPage({Key key, this.topic}) : super(key: key);
  final String topic;

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {

  List<Post> parsePosts(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<List<Map<String, dynamic>>>();
    List<Post> parsedPosts = parsed.map<Post>((json) => Post.fromJson(json)).toList();
    return parsedPosts;
  }

  Future<List<Post>> fetchPosts() async {
    final response = await http.get("http://localhost:8080/post");
    return parsePosts(response.body);
  }

  @override
  Widget build(BuildContext context) {
    // FIXME: all the subtopics will be fetched from the server
    // for now, we just put placeholders instead
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.topic),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ),
      body: Center(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child:
//              ListView.separated(
//                itemBuilder: (_, idx) => Text('Item $idx', textAlign: TextAlign.center,),
//                separatorBuilder: (a, b) => Divider(),
//                itemCount: 100,
//              ),
              Text(''),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: ListView(
                  children: [
                    Divider(height: 20.0,),
                    Card(
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SubtopicPage(subtopic: widget.topic + ': Subtopic',)),
                          );
                          print('Subtopic');
                        },
                        child: Container(
                          color: Colors.orange,
                          width: 300,
                          height: 100,
                          child: Center(
                            child: Text('Subtopic', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ),
                    Divider(height: 20.0,),
                  ],
                  scrollDirection: Axis.vertical,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child:
//              ListView.separated(
//                itemBuilder: (_, idx) => Text('Item $idx', textAlign: TextAlign.center,),
//                separatorBuilder: (a, b) => Divider(),
//                itemCount: 100,
//              ),
              Text(''),
            ),
          ],
        ),
      ),
    );
  }

}
