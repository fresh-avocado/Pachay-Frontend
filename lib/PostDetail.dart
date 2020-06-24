import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:js' as js;
import 'Topic_Page.dart' show Post;

class PostDetail extends StatefulWidget {
  PostDetail({Key key, this.post, this.appBarColor}) : super(key: key);
  final Post post;
  final Color appBarColor;

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {

  void rated(bool like) {
    widget.post.ratingCount++;
    if (like) {
      widget.post.rating++;
    }
    setState(() {});
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
                        onPressed: () {
                          rated(true);
                          // TODO: mandar el PUT al servidor
                        }),
                  ),
                  ListTile(
                    leading: Text(widget.post.author),
                    subtitle: Text(widget.post.datePublished),
                    trailing: IconButton(
                        icon: Icon(Icons.thumb_down),
                        onPressed: () {
                          rated(false);
                          // TODO: mandar el PUT al servidor
                        }),
                  ),
                  ListTile(
                    trailing: Text("Likes: ${widget.post.rating} | Dislikes: ${widget.post.ratingCount - widget.post.rating}"),
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
                                          js.context.callMethod("open", ["${widget.post.youtubeLinks[idx]}"]);
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
                                    text: "Archivo $idx",
                                    style: TextStyle(color: Colors.blueAccent),
                                    // TODO: hacer el embed del file aca
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