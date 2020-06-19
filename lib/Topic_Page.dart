import 'package:flutter/material.dart';
import 'Subtopic_Page.dart';

class TopicPage extends StatefulWidget {
  TopicPage({Key key, this.topic}) : super(key: key);
  final String topic;

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {

  @override
  Widget build(BuildContext context) {
    // FIXME: all the subtopics will be fetched from the server
    // for now, we just put placeholders instead
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.topic),
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
              flex: 2,
              child: ListView.separated(
                itemBuilder: (_, idx) => Text('Item $idx', textAlign: TextAlign.center,),
                separatorBuilder: (a, b) => Divider(),
                itemCount: 100,
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: ListView(
                  children: [
                    Divider(height: 20.0,),
                    Card(
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SubtopicPage(subtopic: widget.topic + ': Subtopic',)),
                          );
                          print('Subtopic');
                        },
                        child: Container(
                          color: Colors.orange,
                          width: 300,
                          height: 100,
                          child: Center(
                            child: Text('Subtopic', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ),
                    Divider(height: 20.0,),
                  ],
                  scrollDirection: Axis.vertical,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: ListView.separated(
                itemBuilder: (_, idx) => Text('Item $idx', textAlign: TextAlign.center,),
                separatorBuilder: (a, b) => Divider(),
                itemCount: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
