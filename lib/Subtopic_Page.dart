import 'package:flutter/material.dart';

class SubtopicPage extends StatefulWidget {
  SubtopicPage({Key key, this.subtopic}) : super(key: key);
  final String subtopic;

  @override
  _SubtopicPageState createState() => _SubtopicPageState();
}

class _SubtopicPageState extends State<SubtopicPage>{

  @override
  Widget build(BuildContext context) {
    // FIXME: all the subtopics will be fetched from the server
    // for now, we just put placeholders instead
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.subtopic),
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
              child:
              Text(''),
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
                          print('Subtopic page');
                        },
                        child: Container(
                          color: Colors.orange,
                          width: 300,
                          height: 100,
                          child: Center(
                            child: Text('All subtopic posts will be listed here.', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
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
              child:
              Text(''),
            ),
          ],
        ),
      ),
    );
  }
}