import 'package:flutter/material.dart';
import 'dart:convert' show jsonDecode;
import 'Post.dart' show Post;

showAlertDialog(BuildContext context, String title, String message, bool shouldPopTwice) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
      if (shouldPopTwice) {
        Navigator.of(context).pop();
      }
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

List<Post> parsePosts(String responseBody, String userId) {
  List<dynamic> jsonPostList = jsonDecode(responseBody) as List<dynamic>;
  print(jsonPostList);
  List<Post> parsedPosts = List<Post>();
  jsonPostList.forEach((post) {
    print(post);
    parsedPosts.add(Post.fromJson(post as Map<String, dynamic>, userId));
  });
  return parsedPosts;
}