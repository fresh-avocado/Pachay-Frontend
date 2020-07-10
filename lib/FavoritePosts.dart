import 'package:flutter/material.dart';
import 'register.dart' show getSharedPref;
import 'package:Pachay/Post.dart';
import 'utilities.dart';
import 'package:http/http.dart' as http show get;

// TODO: embellecer y mostrarle información relevante al usuario

class FavoritePosts extends StatefulWidget {
  FavoritePosts({Key key, this.title, this.backgroundColor, this.appBarColor}) : super(key: key);
  final String title;
  Color backgroundColor;
  Color appBarColor;

  @override
  FavoritePostsState createState() => FavoritePostsState();
}

class FavoritePostsState extends State<FavoritePosts> {

  Future<List<Post>> fetchFavoritePosts() async {
    //FIXME: actualizar el request
    final String userId = await getSharedPref("userId");
    final token = await getSharedPref("authToken");
    final response = await http.get("http://localhost:8080/post/", headers: {"Authorization": "Bearer $token"});
    return parsePosts(response.body, userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
          title: Text(widget.title,),
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
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Posts Favoritos",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 40,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 30,
              child: FutureBuilder<List<Post>>(
                // FIXME: uncomment this when endpoint and backend funtionality are done
//                future: !widget.orderByRating ? fetchPostsByTopicAndSubtopic() : fetchPostsByTopicAndSubtopicOrderedByRating(),
                future: fetchFavoritePosts(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData ? PostList(posts: snapshot.data, appBarColor: widget.appBarColor, inTeacherProfilePage: false, backgroundColor: widget.backgroundColor, canDelete: false,) : Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}