import 'package:Pachay/Subtopic_Page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopicPage extends StatefulWidget {
  TopicPage({Key key, this.topic, this.subtopics, this.appBarColor}) : super(key: key);
  final String topic;
  final Color appBarColor;
  final List<String> subtopics;

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: widget.appBarColor,
            title: Text(widget.topic),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            )
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: Text(''),),
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: widget.subtopics.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      margin: EdgeInsets.all(15.0),
                      elevation: 5,
                      color: widget.appBarColor,
                      child: InkWell(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text(
                                widget.subtopics[index],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              subtitle: Text(""),
                            ),
                            Text(""),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SubtopicPage(topic: widget.topic, subtopic: widget.subtopics[index], appBarColor: widget.appBarColor,)),
                          );
                        },
                      ),
                    );
                  },
                  scrollDirection: Axis.vertical,
                ),
              ),
            ),
            Expanded(flex: 1, child: Text(''),),
          ],
        )
    );
  }
}

