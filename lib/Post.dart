import 'package:flutter/material.dart';
import 'PostDetail.dart' show PostDetail;
import 'package:http/http.dart' as http;
import 'utilities.dart' show showAlertDialog;
import 'register.dart' show getSharedPref;

class Post {
  final String title;
  final String desc;
  final String author;
  final String datePublished;
  int rating;
  final List<String> youtubeLinks;
  final String postId;
  bool hasRated = false;
  bool hasLiked = false;
  bool hasDisliked = false;
//TODO:  final List<File> files;

  Post({Key key, this.title, this.desc, this.postId, this.author, this.datePublished, this.rating, this.youtubeLinks, this.hasRated, this.hasLiked, this.hasDisliked});

  factory Post.fromJson(Map<String, dynamic> body, String userId) {
    String author = "${body['author']['firstName']} ${body['author']['lastName']}";
    bool hasRated = body['likes']['$userId'] != null ? true : false;
    bool hasLiked = false;
    bool hasDisliked = false;
    if (hasRated) {
      hasLiked = body['likes']['$userId'] == 1;
      hasDisliked = body['likes']['$userId'] == -1;
    }
    return Post(
        title: body['title'],
        desc: body['description'],
        author: author,
        datePublished: body['date'].toString().substring(0, 10),
        rating: body['rating'],
        postId: body['postId'],
        youtubeLinks: body['videos'].cast<String>(),
        hasRated: hasRated,
        hasLiked: hasLiked,
        hasDisliked: hasDisliked
    );
  }
}

class PostList extends StatefulWidget {
  final List<Post> posts;
  final Color appBarColor;
  final bool inTeacherProfilePage;

  PostList({Key key, this.posts, this.appBarColor, this.inTeacherProfilePage}) : super(key: key);

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {

  _navigateAndDisplaySelection(BuildContext context, Post post) async {
    final _ = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostDetail(post: post, appBarColor: widget.appBarColor)),
    );
    setState(() {});
  }

  Future<bool> deletePost(String id) async {
    String token = await getSharedPref("authToken");
    final http.Response response = await http.delete(
        'http://localhost:8080/post/$id',
        headers: <String, String>{
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

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
                  trailing: Text("Rating: ${post.rating}"),
                ),
                ListTile(
                  title: Text("Autor: ${post.author}"),
                  subtitle: Text("Publicado en: ${post.datePublished}"),
                  trailing: Column(
                    children: [
                      RaisedButton(
                        child: Text("Ver más"),
                        onPressed: () {
                          _navigateAndDisplaySelection(context, post);
                        },
                      ),
                    ],
                  ),
                ),
                if (widget.inTeacherProfilePage) IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // set up the button
                    Widget siButton = FlatButton(
                      child: Text("Sí"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        deletePost(widget.posts[index].postId).then( (success) {
                          widget.posts.removeWhere( (post) => post.postId == widget.posts[index].postId);
                          if (success) {
                            showAlertDialog(context, "Éxito", "El Post fue borrado exitósamente.", false);
                          } else {
                            showAlertDialog(context, "Oh no", "El Post no pudo ser borrado.\nInténtalo de nuevo más tarde.", false);
                          }
                          setState(() {});
                        });
                      },
                    );

                    Widget noButton = FlatButton(
                      child: Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    );

                    // set up the AlertDialog
                    AlertDialog alert = AlertDialog(
                      title: Text("Estás seguro(a) que quieres borrar el Post?"),
                      content: Text("Esta acción es irreversible."),
                      actions: [
                        siButton,
                        noButton
                      ],
                    );

                    // show the dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  },
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