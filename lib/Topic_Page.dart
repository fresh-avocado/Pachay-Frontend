import 'dart:convert';

import 'package:flutter/cupertino.dart';
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
      youtubeLinks: body['videos'].cast<String>()
    );
  }
}

class PostList extends StatelessWidget {
  final List<Post> posts;

  PostList({Key key, this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        Post post = posts[index];
        return Card(
          child: ListTile(
            leading: Icon(Icons.note),
            title: Text(post.title),
            subtitle: Text("Autor: ${post.author}"),
          ),
          color: Colors.white70,
          elevation: 2,
          margin: EdgeInsets.all(30.0),
        );
          ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                leading: Icon(Icons.note),
                title: Text(post.title),
                subtitle: Text("Autor: ${post.author}"),
              ),
              Text(post.desc),
              Text(post.datePublished),
              Text("${post.rating}/${post.ratingCount}"),
              ListView.separated(
                itemCount: post.youtubeLinks.length,
                itemBuilder: (_, idx) => Text(post.youtubeLinks[idx], textAlign: TextAlign.center,),
                separatorBuilder: (a, b) => Divider(),
              ),
            ],
          );
      },
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
    List<dynamic> jsonPostList = jsonDecode(responseBody) as List<dynamic>;
    print(jsonPostList);
    List<Post> parsedPosts = List<Post>();
    jsonPostList.forEach((post) {
      print(post);
      parsedPosts.add(Post.fromJson(post as Map<String, dynamic>));
    });
    print(parsedPosts);
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
                return snapshot.hasData ? PostList(posts: snapshot.data) : Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Expanded(flex: 1, child: Text(''),),
        ],
      )
    );
  }

}
