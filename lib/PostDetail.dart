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

  Future<bool> downloadFile(String filename) async {
    final http.Response response = await http.get(
      'http://localhost:8080/file/download/$filename'
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print("$filename could not be downloaded");
      return false;
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
                // TODO: poner el rating en el medio de los arrows, que solo muestre el numero y no "Rating: "
                children: [
                  ListTile(
                    subtitle: Text(widget.post.desc),
                    trailing: IconButton(
                        icon: Icon(Icons.arrow_upward),
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
                    title: Text(widget.post.author),
                    subtitle: Text(widget.post.datePublished),
                    trailing: IconButton(
                        color: widget.post.hasRated && !widget.post.hasLiked ? Colors.blueAccent : Colors.grey,
                        icon: Icon(Icons.arrow_downward),
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
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Links a Videos",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
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
                      flex: 1,
                      child: Text(
                        "Material de Soporte",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (widget.post.material != null && widget.post.material.length > 0) Expanded(
                      flex: 3,
                      child: Center(
                        child: ListView.separated(
                          itemCount: widget.post.material.length,
                          separatorBuilder: (BuildContext context, int index) => Divider(),
                          itemBuilder: (BuildContext ctx, int idx) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: "${widget.post.material[idx]}",
                                    style: TextStyle(color: Colors.blueAccent),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        downloadFile(widget.post.material[idx]);
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
                      flex: 1,
                      child: Text(
                        "Ejercicios",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (widget.post.ejercicios != null && widget.post.ejercicios.length > 0) Expanded(
                      flex: 3,
                      child: Center(
                        child: ListView.separated(
                          itemCount: widget.post.ejercicios.length,
                          separatorBuilder: (BuildContext context, int index) => Divider(),
                          itemBuilder: (BuildContext ctx, int idx) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: "${widget.post.ejercicios[idx]}",
                                    style: TextStyle(color: Colors.blueAccent),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        downloadFile(widget.post.material[idx]);
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
                      flex: 1,
                      child: Text(
                        "Solucionarios",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (widget.post.solucionario != null && widget.post.solucionario.length > 0) Expanded(
                      flex: 3,
                      child: Center(
                        child: ListView.separated(
                          itemCount: widget.post.solucionario.length,
                          separatorBuilder: (BuildContext context, int index) => Divider(),
                          itemBuilder: (BuildContext ctx, int idx) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: "${widget.post.solucionario[idx]}",
                                    style: TextStyle(color: Colors.blueAccent),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        downloadFile(widget.post.material[idx]);
                                      }
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