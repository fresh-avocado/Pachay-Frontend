import 'package:Pachay/Subtopic_Page.dart' show SubtopicPage;
import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class TopicPage extends StatefulWidget {
  TopicPage({Key key, this.topic, this.subtopics, this.appBarColor, this.subtopicIcons, this.titleImage, this.subtopicImages}) : super(key: key);
  final String topic;
  final Color appBarColor;
  final List<String> subtopics;
  final List<String> subtopicImages;
  final List<Icon> subtopicIcons;
  final Image titleImage;

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: globals.backgroundColor,
        appBar: AppBar(
            backgroundColor: widget.appBarColor,
            title: widget.titleImage,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 2, child: Text(''),),
              Expanded(
                flex: 5,
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
                              Text(""),
                              ListTile(
                                leading: widget.subtopicIcons[index],
                                title: Image.asset(
                                  'pachaylogo/'+widget.subtopicImages[index],
                                  fit: BoxFit.contain,
                                  height: 30,),
                                trailing: Icon(Icons.arrow_forward_ios),
                              ),
                              Text(""),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SubtopicPage(
                                  subtopicImage: Image.asset(
                                    'pachaylogo/'+widget.subtopicImages[index],
                                    fit: BoxFit.contain,
                                    height: 60,
                                  ),
                                  subtopic: widget.subtopics[index],
                                  appBarColor: widget.appBarColor)),
                            );
                          },
                        ),
                      );
                    },
                    scrollDirection: Axis.vertical,
                  ),
                ),
              ),
              Expanded(flex: 2, child: Text(''),),
            ],
          ),
        )
    );
  }
}

