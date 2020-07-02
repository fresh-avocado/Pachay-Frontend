import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'register.dart' show getSharedPref;
import 'utilities.dart' show showAlertDialog;
import 'dart:html' as html;

// TODO: validar que los links sean links de youtbe BIEN ESCRITOS, si existen o no, es no nos concierne
// TODO: BASE 64

class Link extends StatelessWidget {
  var _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 24.0),
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          contentPadding:
          EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          labelText: "Link de YouTube"
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Agregar un URL o eliminar el cuadro de texto.';
          }
          // TODO: validar qu sea un url de youtube valido, osea bien escrito
          return null;
        },
        maxLines: 1,
      ),
    );
  }
}

class NewPostPage extends StatefulWidget {
  final String title;
  final Map<String, List<String>> topicsAndSubtopics;

  NewPostPage({Key key, this.title, this.topicsAndSubtopics}) : super(key: key);

  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {

  final postTitle = TextEditingController();
  final postDesc = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool hasChosenSubtopic = false;
  String _topic = "Matemática";
  String _subtopic = "Ecuaciones";
  List<Widget> linkWidgets = List<Widget>();
  List<String> ejercicios = List<String>();
  List<String> materialDeSoporte = List<String>();
  List<String> solucionarios = List<String>();
  bool ejerciciosButtonDisabled = false;
  bool materialButtonDisabled = false;
  bool solucionariosButtonDisabled = false;


  Future<void> chooseFiles(String tipo) async {
    html.InputElement uploadInput = html.FileUploadInputElement();
    // FIXME: does this allow a single file to be uploaded?
    uploadInput.draggable = true;
    uploadInput.click();
    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      final file = files[0];
      final reader = new html.FileReader();
      reader.onLoadEnd.listen( (e) {
        handleUploadedFile(reader.result, tipo);
      });
      reader.readAsDataUrl(file);
      // TODO: validate file type?
    });
  }

  void handleUploadedFile(Object result, String tipo) {
    // TODO: mostrar el nombre del archivo seleccionado y dar la opcion de borrar el archivo subido
    // TODO: permitir subida de ciertos tipos de archivos
    String base64EncodedFile = result.toString().split(",").last;
    print("BASE 64 $tipo FILE: <$base64EncodedFile>");
    if (tipo == "ejercicio") {
      ejercicios.add(base64EncodedFile);
      ejerciciosButtonDisabled = true;
    } else if (tipo == "material") {
      materialDeSoporte.add(base64EncodedFile);
      materialButtonDisabled = true;
    } else if (tipo == "solucionario") {
      solucionarios.add(base64EncodedFile);
      solucionariosButtonDisabled = true;
    }
    setState(() {});
  }

  Future<bool> postPost(String postTitle, String postDesc, List<String> links) async {
    String token = await getSharedPref("authToken");

    final http.Response preloadFilesResponse = await http.post(
      'http://localhost:8080/files/upload',
      headers: <String, String> {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(<String, dynamic>{
        "ejercicios": ejercicios,
        "solucionario": solucionarios,
        "soporte": materialDeSoporte
      })
    );

    Map<String, dynamic> files;
    if (preloadFilesResponse.statusCode == 200) {
        files = jsonDecode(preloadFilesResponse.body) as Map<String, dynamic>;
    } else {
      print('Preloading file request failed.');
      return false;
    }

    final http.Response response = await http.post(
      'http://localhost:8080/post',
      headers: <String, String>{
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(<String, dynamic>{
        "title": postTitle,
        "description": postDesc,
        "topic": _topic,
        "subtopic": _subtopic,
        "videos": links,
        "ejercicios": files['ejercicios'],
        "solucionario": files['solucionario'],
        "soporte": files['soporte']
      }),
    );

    print("REQUEST");
    print(response.request);

    if (response.statusCode == 200) {
      // post uploaded successfully
      return true;
    } else if (response.statusCode == 500) {
      // bad request
      return false;
    } else {
      return false;
    }
  }

  void updateDropDown(String __topic, String __subtopic) {
    _topic = __topic;
    _subtopic = __subtopic;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
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
          body: SingleChildScrollView(
            child: Center(
              child: Form(
                autovalidate: true,
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 28),
                  child: Column(
                    children: <Widget>[
                      Divider(height: 20),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(30.0),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              maxLength: 50,
                              decoration: InputDecoration(
                                labelText: 'Título de Post',
                              ),
                              controller: postTitle,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'El Post debe tener título.';
                                }
                                return null;
                              },
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.all(30.0),
                            ),
                          )
                        ],
                      ),
                      Divider(height: 20),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(30.0),
                          ),
                          Expanded(
                            flex: 5,
                            child: TextFormField(
                              maxLength: 100,
                              controller: postDesc,
                              decoration: InputDecoration(
                                labelText: 'Descripción del Post',
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'El Post debe tener una breve descripción.';
                                }
                                return null;
                              },
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.all(30.0),
                            ),
                          )
                        ],
                      ),
                      Divider(height: 20),
                      Column(
                        children: List.generate(linkWidgets.length, (i) {
                          return linkWidgets[i];
                        }),
                      ),
                      Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Align(
                            alignment: Alignment.bottomRight,
                            child: FloatingActionButton(
                              heroTag: 1,
                              child: Text(
                                '+',
                                style: TextStyle(fontSize: 20.0),
                              ),
                              onPressed: () {
                                setState(() {
                                  linkWidgets.add(Link());
                                });
                              },
                            ),
                          ),
                          Text("Links a video de Youtube",
                            style: TextStyle(fontSize: 20),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: FloatingActionButton(
                              heroTag: 2,
                              child: Text(
                                '-',
                                style: TextStyle(fontSize: 20.0),
                              ),
                              onPressed: () {
                                setState(() {
                                  linkWidgets.removeLast();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButton<String>(
                            value: _topic,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String newValue) {
                              print("Topic: $newValue");
                              setState(() {
                                updateDropDown(newValue, widget.topicsAndSubtopics[newValue].first);
                              });
                            },
                            items: widget.topicsAndSubtopics.keys.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          Divider(thickness: 0,),
                          DropdownButton<String>(
                            value: _subtopic,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String newValue) {
                              print("Subtopic: $newValue");
                              setState(() {
                                updateDropDown(_topic, newValue);
                              });
                            },
                            items: widget.topicsAndSubtopics[_topic].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      // TODO: agregar boton que permite borrar el archivo seleccionado para seleccionar otra vez
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MaterialButton(
                            color: Colors.orange,
                            elevation: 8,
                            highlightElevation: 2,
                            child: Text('Seleccionar Ejercicio'),
                            onPressed: () {
                              if (!ejerciciosButtonDisabled) {
                                chooseFiles("ejercicio");
                              } else {
                                return null;
                              }
                            },
                          ),
                          MaterialButton(
                            color: Colors.orange,
                            elevation: 8,
                            highlightElevation: 2,
                            child: Text('Seleccionar Solucionario'),
                            onPressed: () {
                              if (!solucionariosButtonDisabled) {
                                chooseFiles("solucionario");
                              } else {
                                return null;
                              }
                            },
                          ),
                          MaterialButton(
                            color: Colors.orange,
                            elevation: 8,
                            highlightElevation: 2,
                            child: Text('Seleccionar Material de Soporte'),
                            onPressed: () {
                              if (!materialButtonDisabled) {
                                chooseFiles("material");
                              } else {
                                return null;
                              }
                            },
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          width: 200,
                          child: Row(
                            children: [
                              MaterialButton(
                                  elevation: 8,
                                  highlightElevation: 2,
                                  child: Text("Publicar Post"),
                                  color: Colors.blue,
                                  onPressed: () {
                                    print("Topic: $_topic\nSubtopic: $_subtopic");
                                    if (_formKey.currentState.validate()) {
                                      String _postTitle = postTitle.text;
                                      String _postDesc = postDesc.text;
                                      List<String> youtubeLinks = List<String>();
                                      String _link;
                                      print("Subiendo Post del Profesor:\nPost Title: $_postTitle\nPost Description: $_postDesc\nTopic: $_topic\nSubtopic: $_subtopic");
                                      for (int i = 0; i < linkWidgets.length; i++) {
                                        _link = (linkWidgets[i] as Link)._controller.text;
                                        youtubeLinks.add(_link);
                                      }
                                      postPost(_postTitle, _postDesc, youtubeLinks).then( (success) {
                                        if (success) {
                                          showAlertDialog(context, "Éxito", "El Post fue subido exitósamente.", true);
                                        } else {
                                          showAlertDialog(context, "Uy No", "El Post no pudo ser subido.\nIntenta de nuevo.", false);
                                        }
                                      });
                                    }
                                  }
                              ),
                              Padding(
                                padding: EdgeInsets.all(30.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ),
    );
  }
}