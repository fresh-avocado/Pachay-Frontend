import 'package:flutter/material.dart';
import 'register.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.title, this.role}) : super(key: key);
  final String title;
//  final String username;
  final bool role;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Future<String> getFirstName() async {
    String firstName = await getSharedPref("firstName");
    if (firstName != null) {
      return firstName;
    } else {
      // nunca deber'ia llegar a este else KERNEL_PANIC()
      return "Error jajaja";
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
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Row(
              children: <Widget>[
                FutureBuilder<String>(
                  future: getFirstName(),
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    Widget homePage;
                    if (snapshot.hasData) {
                      homePage = Text(
                        widget.role == false ? "Bienvenido Profesor ${snapshot.data}" : "Bienvenido Alumno ${snapshot.data}",
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
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: Text("Experiencia: ")),
          Expanded(
            flex: 10,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, idx) => !widget.role?Text('   Post Guardado #$idx   ', textAlign: TextAlign.center,):Text('   Mi Post #$idx   ', textAlign: TextAlign.center,),
              separatorBuilder: (a, b) => Divider(),
              itemCount: 100,
            ),
          )
        ],
      ),
    );
  }
}