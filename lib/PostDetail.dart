import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:flutube/flutube.dart';
import 'Post.dart' show Post;
import 'package:url_launcher/url_launcher.dart' show launch;
import 'register.dart' show getSharedPref;
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;
import 'globals.dart' as globals;

// cristian flores

class PostDetail extends StatefulWidget {
  PostDetail({Key key, this.post, this.appBarColor}) : super(key: key) {
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
        widget.post.hasDisliked = false;
      } else {
        widget.postLiked = true;
        widget.postDisliked = false;
        widget.post.hasLiked = true;
        widget.post.hasRated = true;
        widget.post.hasDisliked = false;
      }
    } else {
      if (widget.postDisliked) {
        widget.postLiked = false;
        widget.postDisliked = false;
        widget.post.hasRated = false;
        widget.post.hasLiked = false;
        widget.post.hasDisliked = false;
      } else {
        widget.postDisliked = true;
        widget.postLiked = false;
        widget.post.hasLiked = false;
        widget.post.hasDisliked = true;
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
    print("${widget.post.hasRated ? "Post has been rated." : "Post has not been rated"}");
    return Scaffold(
      backgroundColor: globals.backgroundColor,
      appBar: AppBar(
          title: Text(widget.post.subtopic),
          backgroundColor: widget.appBarColor,
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
        child: Column(
            children: [
              Expanded(
                flex: 8,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(""),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "${widget.post.author}\n${widget.post.datePublished}\n",
                                style: TextStyle(color: Colors.black,),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        margin: EdgeInsets.all(10),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: widget.appBarColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  margin: EdgeInsets.all(10),
                                  child: Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        widget.post.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 40,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(5),),
                                Expanded(
                                  flex: 7,
                                  child: Text(
                                      widget.post.desc,
                                      style: TextStyle(fontSize: 17),
                                      textAlign: TextAlign.justify
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text("")
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 12,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        margin: EdgeInsets.all(10),
                        child: Center(
                          child: Column(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    color: widget.appBarColor, // FIXME: este color esta bien?
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  margin: EdgeInsets.all(10),
                                  child: Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        "Videos",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 40,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ),
                              ),
                              Padding(padding: EdgeInsets.all(5),),
                              Expanded(
                                flex: 3,
                                child: Center(
                                  child: ListView.separated(
                                    itemCount: widget.post.youtubeLinks.length,
                                    separatorBuilder: (BuildContext context, int index) => Divider(),
                                    itemBuilder: (BuildContext ctx, int idx) {
                                      return Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                // TODO: HACER EL EMBED DE YOUTUBE
                                                  text: "Video ${idx+1}",
                                                  style: TextStyle(
                                                      color: Colors.blueAccent,
                                                      fontSize: 15
                                                  ),
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () {
                                                      // TODO: hacer el embed de los videos de youtube
                                                      launch(widget.post.youtubeLinks[idx]).then((value) => {});
                                                    }
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                launch(widget.post.youtubeLinks[idx]).then((value) => {});
                                              },
                                              child: FluTube(
                                                widget.post.youtubeLinks[idx],
                                                aspectRatio: 16 / 9,
                                                autoPlay: false,
                                                looping: false,
                                                onVideoStart: () {},
                                                onVideoEnd: () {},
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow

                            ),
                          ],
                        ),
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: widget.appBarColor, // FIXME: este color esta bien?
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              margin: EdgeInsets.all(10),
                              child: Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    "Archivos Adjuntos",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(5),),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Material de Soporte",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
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
                                              text: "Material de Soporte ${idx+1}",
                                              style: TextStyle(
                                                  color: Colors.blueAccent,
                                                  fontSize: 15
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  launch('http://localhost:8080/files/download/${widget.post.material[idx]}').then((value) => {});
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
                              child: Text(
                                "Ejercicios",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
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
                                              text: "Ejercicio ${idx+1}",
                                              style: TextStyle(
                                                  color: Colors.blueAccent,
                                                  fontSize: 15
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  launch('http://localhost:8080/files/download/${widget.post.ejercicios[idx]}').then((value) => {});
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
                              child: Text(
                                "Solucionarios",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
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
                                              text: "Solucionario ${idx+1}",
                                              style: TextStyle(
                                                  color: Colors.blueAccent,
                                                  fontSize: 15
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  launch('http://localhost:8080/files/download/${widget.post.solucionario[idx]}').then((value) => {});
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
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.appBarColor, // FIXME: este color esta bien?
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  margin: EdgeInsets.all(10),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              "Nos gustaria saber tu opinión de este post:   ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),
                          ),
                          IconButton(
                              icon: Icon(Icons.tag_faces),
                              color: widget.post.hasRated && widget.post.hasLiked ? Colors.blueAccent : Colors.grey,
                              onPressed: () {
                                ratePost(widget.post.postId, "like").then( (newRating) {
                                  if (newRating != "error") {
                                    rated(true, newRating);
                                  }
                                });
                              }),
                          Text(
                              "${widget.post.rating}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                              ),
                          ),
                          IconButton(
                              color: widget.post.hasRated && widget.post.hasDisliked ? Colors.blueAccent : Colors.grey,
                              icon: Icon(Icons.face),
                              onPressed: () {
                                ratePost(widget.post.postId, "dislike").then( (newRating) {
                                  if (newRating != "error") {
                                    rated(false, newRating);
                                  }
                                });
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }

}