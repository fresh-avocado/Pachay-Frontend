import 'package:Pachay/UnverifiedPosts.dart' show UnverifiedPosts;
import 'package:flutter/material.dart';
import 'register.dart' show getSharedPref;

// TODO: embellecer y mostrarle información relevante al usuario

class ModeratorPage extends StatefulWidget {
  ModeratorPage({Key key, this.title, this.backgroundColor, this.appBarColor}) : super(key: key);
  final String title;
  Color backgroundColor;
  Color appBarColor;

  @override
  ModeratorPageState createState() => ModeratorPageState();
}

class ModeratorPageState extends State<ModeratorPage> {

  Future<String> getNames() async {
    String firstName = await getSharedPref("firstName");
    String lastName = await getSharedPref("lastName");
    if (firstName != null) {
      return "$firstName $lastName";
    } else {
      // nunca deberia llegar a este else KERNEL_PANIC()
      return "no se puedo obtener el firstName del key-value pair";
    }
  }

  // TODO: si es moderador mostrar los posts que tienen que ser validados!!!!
  // TODO: al ser validados o rechazados, mandar un request al server para que los marque como aceptados o rechazados

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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text(""),
            ),
            Expanded(
              flex: 4,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    child: Text("Posts No Verificados"),
                    color: widget.appBarColor,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UnverifiedPosts(
                                  title: "Posts No Verificados",
                                  backgroundColor: widget.backgroundColor,
                                  appBarColor: widget.appBarColor,
                                  inModeratorView: true,
                                )
                        ),
                      );
                      print("Posts No Verificados");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}