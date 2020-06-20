import 'package:flutter/material.dart';
import 'register.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.title, this.role}) : super(key: key);
  final String title;
  final bool role;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Future<String> getNames() async {
    String firstName = await getSharedPref("firstName");
    String lastName = await getSharedPref("lastName");
    if (firstName != null) {
      return "$firstName $lastName";
    } else {
      // nunca deber'ia llegar a este else KERNEL_PANIC()
      return "no se puedo obtener el firstName del key-value pair";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
              flex: 3,
              child: FutureBuilder<String>(
                future: getNames(),
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  Widget homePage;
                  if (snapshot.hasData) {
                    homePage = Text(
                      widget.role == false ? "Profesor ${snapshot.data}" : "Alumno ${snapshot.data}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    );
                  } else {
                    homePage = CircularProgressIndicator();
                  }
                  return homePage;
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Text("Acá saldrán los videos que Pachay le sugiere al alumno."),
            ),
          ],
        ),
      ),
    );
  }
}