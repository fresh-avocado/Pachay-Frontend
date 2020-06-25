import 'package:flutter/material.dart';
import 'PostDetail.dart' show PostDetail;

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
                  trailing: Text("${post.rating} likes"),
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