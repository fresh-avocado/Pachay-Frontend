import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'Post.dart';
import 'package:url_launcher/url_launcher.dart';
import 'register.dart' show getSharedPref;
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;

class PostDetail extends StatefulWidget {
  PostDetail({Key key, this.post, this.appBarColor}) : super(key: key) {
    // FIXME: bug que pone el dislike en azul cuando no ha dislikeado
    if (post.hasRated) {
      if (post.hasLiked) {
        postLiked = true;
        postDisliked = false;
      } else if (post.hasDisliked) {
        postLiked = false;
        postDisliked = true;
      } else {
        postLiked = false;
        postDisliked = false;
      }
    } else {
      postLiked = false;
      postDisliked = false;
    }
  }
  final Post post;
  final Color appBarColor;
  bool postLiked;
  bool postDisliked;
  String cachedToken = "";

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {

  void rated(bool like, String newRating) {
    if (like) {
      if (widget.postLiked) {
        widget.postLiked = false;
        widget.postDisliked = false;
        widget.post.hasRated = false;
        widget.post.hasLiked = false;
      } else {
        widget.postLiked = true;
        widget.postDisliked = false;
        widget.post.hasLiked = true;
        widget.post.hasRated = true;
      }
    } else {
      if (widget.postDisliked) {
        widget.postLiked = false;
        widget.postDisliked = false;
        widget.post.hasRated = false;
        widget.post.hasLiked = false;
      } else {
        widget.postDisliked = true;
        widget.postLiked = false;
        widget.post.hasLiked = false;
        widget.post.hasRated = true;
      }
    }
    widget.post.rating = int.parse(newRating);
    setState(() {});
  }

  Future<String> ratePost(String id, String action) async {
    if (widget.cachedToken == "") {
      widget.cachedToken = await getSharedPref("authToken");
    }
    final http.Response response = await http.post(
        'http://localhost:8080/post/$action/$id',
        headers: <String, String>{
          "Authorization": "Bearer ${widget.cachedToken}",
        });

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      return responseBody['rating'].toString();
    } else {
      print("Bad request");
      return "error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.post.title),
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
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  ListTile(
                    subtitle: Text(widget.post.desc),
                    trailing: IconButton(
                        icon: Icon(Icons.thumb_up),
                        color: widget.post.hasRated && widget.post.hasLiked ? Colors.blueAccent : Colors.grey,
                        onPressed: () {
                          ratePost(widget.post.postId, "like").then( (newRating) {
                            if (newRating != "error") {
                              rated(true, newRating);
                            }
                          });
                        }),
                  ),
                  ListTile(
                    leading: Text(widget.post.author),
                    subtitle: Text(widget.post.datePublished),
                    trailing: IconButton(
                        color: widget.post.hasRated && !widget.post.hasLiked ? Colors.blueAccent : Colors.grey,
                        icon: Icon(Icons.thumb_down),
                        onPressed: () {
                          ratePost(widget.post.postId, "dislike").then( (newRating) {
                            if (newRating != "error") {
                              rated(false, newRating);
                            }
                          });
                        }),
                  ),
                  ListTile(
                    trailing: Text("Rating: ${widget.post.rating}"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: ListView.separated(
                          itemCount: widget.post.youtubeLinks.length,
                          separatorBuilder: (BuildContext context, int index) => Divider(),
                          itemBuilder: (BuildContext ctx, int idx) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                RichText(
                                  text: TextSpan(
                                      text: "Link $idx",
                                      style: TextStyle(color: Colors.blueAccent),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // TODO: hacer el embed de los videos de youtube
                                          launch(widget.post.youtubeLinks[idx]).then((value) => {});
                                        }
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: ListView.separated(
                          itemCount: widget.post.youtubeLinks.length,
                          separatorBuilder: (BuildContext context, int index) => Divider(),
                          itemBuilder: (BuildContext ctx, int idx) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    // TODO: abrir el archivo en otra ventana del browser?
                                    text: "Archivo $idx",
                                    style: TextStyle(color: Colors.blueAccent),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}