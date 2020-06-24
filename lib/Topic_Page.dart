import 'dart:convert';
import 'package:Pachay/PostDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
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

class Post {
  final String title;
  final String desc;
  final String author;
  final String datePublished;
  int rating;
  int ratingCount;
  final List<String> youtubeLinks;
//TODO:  final List<File> files;

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
      youtubeLinks: body['videos'].cast<String>()
    );
  }
}

class PostList extends StatefulWidget {
  final List<Post> posts;
  final Color appBarColor;

  PostList({Key key, this.posts, this.appBarColor}) : super(key: key);

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.posts.length,
      itemBuilder: (context, index) {
        Post post = widget.posts[index];
        return Expanded(
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  leading: Icon(Icons.note),
                  title: Text(post.title),
                ),
                ListTile(
                  title: Text(post.desc),
                ),
                ListTile(
                  title: Text("Autor: ${post.author}"),
                  subtitle: Text("Publicado en: ${post.datePublished}"),
                  trailing: Column(
                    children: [
                      RaisedButton(
                        child: Text("Ver más"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostDetail(post: post, appBarColor: widget.appBarColor),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            color: Colors.white70,
            elevation: 3,
            margin: EdgeInsets.all(30.0),
          ),
        );
      },
    );
  }
}