import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'Post.dart';
import 'package:url_launcher/url_launcher.dart';

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
                          // TODO: mandar el PUT al servidor
                          rated(true);
                        }),
                  ),
                  ListTile(
                    leading: Text(widget.post.author),
                    subtitle: Text(widget.post.datePublished),
                    trailing: IconButton(
                        icon: Icon(Icons.thumb_down),
                        onPressed: () {
                          // TODO: mandar el PUT al servidor
                          rated(false);
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