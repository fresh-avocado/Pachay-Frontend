import 'package:flutter/material.dart';
import 'PostDetail.dart' show PostDetail;
import 'package:http/http.dart' as http;
import 'utilities.dart' show showAlertDialog;
import 'register.dart' show getSharedPref;

/// TODO: añadir un flag que añade dos botones: 'aceptar' y 'rechazar'
/// este flag solo esta para los moderadores

class Post {
  final String title;
  final String desc;
  final String author;
  final String datePublished;
  final String topic;
  final String subtopic;
  int rating;
  final List<String> youtubeLinks;
  final String postId;
  bool hasRated = false;
  bool hasLiked = false;
  bool hasDisliked = false;
  final List<String> ejercicios;
  final List<String> solucionario;
  final List<String> material;
  bool markedAsFavorite;

  Post({Key key,  this.title,
                  this.desc,
                  this.postId,
                  this.author,
                  this.datePublished,
                  this.topic,
                  this.subtopic,
                  this.rating,
                  this.youtubeLinks,
                  this.hasRated,
                  this.hasLiked,
                  this.hasDisliked,
                  this.ejercicios,
                  this.solucionario,
                  this.material,
                  this.markedAsFavorite});

  factory Post.fromJson(Map<String, dynamic> body, String userId) {
    String author = "${body['author']['firstName']} ${body['author']['lastName']}";
    bool hasRated = body['likes']['$userId'] != null;
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
        topic: body['subtopic']['subtopic'],
        subtopic: body['subtopic']['subtopic'],
        rating: body['rating'],
        postId: body['postId'],
        youtubeLinks: body['videos'].cast<String>(),
        hasRated: hasRated,
        hasLiked: hasLiked,
        hasDisliked: hasDisliked,
        ejercicios: (body['ejercicios'] == null) ? [] : body['ejercicios'].cast<String>(),
        solucionario: (body['solucionario'] == null) ? [] : body['solucionario'].cast<String>(),
        material: (body['soporte'] == null) ? [] : body['soporte'].cast<String>(),
        markedAsFavorite: false
        // TODO: agarrar markedAsFavorite del body
    );
  }
}

class PostList extends StatefulWidget {
  final List<Post> posts;
  final Color appBarColor;
  final bool inTeacherProfilePage;
  final context;
  final Color backgroundColor;
  final bool canDelete;
  String cachedToken = "";
  String cachedUserId = "";
  final bool inModeradorProfilePage;

  PostList({Key key, this.posts, this.appBarColor, this.inTeacherProfilePage, this.context, this.backgroundColor, @required this.canDelete, this.inModeradorProfilePage = false}) : super(key: key);

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {

  _navigateAndDisplaySelection(BuildContext context, Post post) async {
    final _ = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostDetail(post: post, appBarColor: widget.appBarColor, backgroundColor: widget.backgroundColor)),
    );
    setState(() {});
  }

  Future<bool> deletePost(String id) async {
    if (widget.cachedToken == "") {
      widget.cachedToken = await getSharedPref("authToken");
    }
    final http.Response response = await http.delete(
        'http://localhost:8080/post/$id',
        headers: <String, String>{
          "Authorization": "Bearer ${widget.cachedToken}",
          "Content-Type": "application/json"
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> markFavoritePost(String id, String action) async {
    // FIXME: le mando el userId y el postId, o el postId me lo saca del token?
//    if (widget.cachedUserId.isEmpty) {
//      widget.cachedUserId = await getSharedPref("userId");
//    }
//    if (widget.cachedToken == "") {
//      widget.cachedToken = await getSharedPref("authToken");
//    }
//    final http.Response response = await http.post(
//        'http://localhost:8080/post/$action/$id',
//        headers: <String, String>{
//          "Authorization": "Bearer ${widget.cachedToken}",
//        });
//
//    if (response.statusCode == 200) {
//      Map<String, dynamic> responseBody = jsonDecode(response.body);
//      return responseBody['favorite'].toString(); // 1 or 0 // FIXME: is this name ok?
//    } else {
//      print("Bad request");
//      return "e";
//    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.posts.length > 0) {
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
                    trailing: !widget.inTeacherProfilePage ? IconButton(
                      icon: Icon( post.markedAsFavorite ? Icons.star : Icons.star_border ),
                      onPressed: () {
//                        markFavoritePost(post.postId, "favorite").then( (isFavorite) {
//                          if (isFavorite != "e") {
//                            post.markedAsFavorite = isFavorite == "1" ? true : false;
//                            if (post.markedAsFavorite) {
//                              Scaffold.of(context).showSnackBar(SnackBar(content: Text("Post Marcado como Favorito"), duration: Duration(seconds: 1),));
//                            } else {
//                              Scaffold.of(context).showSnackBar(SnackBar(content: Text("Post Marcado como No Favorito"), duration: Duration(seconds: 1),));
//                            }
//                            setState(() {});
//                          } else {
//                            Scaffold.of(context).showSnackBar(SnackBar(content: Text("Ocurrió un error"), duration: Duration(seconds: 1),));
//                          }
//                        });
                          if (post.markedAsFavorite) {
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text("Post Marcado como No Favorito"), duration: Duration(seconds: 1),));
                            post.markedAsFavorite = false;
                            setState(() {});
                          } else {
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text("Post Marcado como Favorito"), duration: Duration(seconds: 1),));
                            post.markedAsFavorite = true;
                            setState(() {});
                          }
                      },
                    ) : Text(""),
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
                          color: widget.appBarColor,
                          child: Text("Ver más"),
                          onPressed: () {
                            _navigateAndDisplaySelection(context, post);
                          },
                        ),
                      ],
                    ),
                  ),
                  if (widget.inTeacherProfilePage && widget.canDelete) IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.redAccent,
                    onPressed: () {
                      // set up the button
                      Widget siButton = FlatButton(
                        child: Text("Sí"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          deletePost(widget.posts[index].postId).then( (success) {
                            widget.posts.removeWhere( (post) => post.postId == widget.posts[index].postId);
                            if (success) {
                              showAlertDialog(widget.context, "Éxito", "El Post fue borrado exitósamente.", false);
                            } else {
                              showAlertDialog(widget.context, "Oh no", "El Post no pudo ser borrado.\nInténtalo de nuevo más tarde.", false);
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
                  // FIXME: should be inModeratorProfilePage
                  if (widget.inTeacherProfilePage) Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                          color: Colors.green,
                          child: Text("Aceptar"),
                          onPressed: () {
                            print("El post ha sido verificado");
                          },
                        ),
                        RaisedButton(
                          color: Colors.redAccent,
                          child: Text("Rechazar"),
                          onPressed: () {
                            print("El post ha sido rechazado");
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              color: Colors.white,
              elevation: 3,
              margin: EdgeInsets.all(30.0),
            ),
          );
        },
      );
    } else {
      if (widget.inTeacherProfilePage) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Hasta ahora usted no tiene posts.",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        );
      } else {
        return Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Por el momento, no hay posts con este subtopic.",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }
    }
  }
}