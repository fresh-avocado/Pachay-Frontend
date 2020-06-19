import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'register.dart' show getSharedPref;

class NewPostPage extends StatefulWidget {
  NewPostPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _NewPostPageState createState() => _NewPostPageState();
}

// for now, we don't upload files, but we will
  void _handleResult(Object result) {
//    setState(() {
//      _bytesData = Base64Decoder().convert(result.toString().split(",").last);
//      _selectedFile = _bytesData;
//      // TODO: maybe insert multiple files? in the future
//    });
  }

class _NewPostPageState extends State<NewPostPage> {

  List<int> _selectedFile;
  Uint8List _bytesData;

  final postTitle = TextEditingController();
  final postDesc = TextEditingController();
  final youtubeLink = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<bool> postPost(String postTitle, String postDesc, List<String> links) async {
    // for now, we don't upload files
//    var url = Uri.parse('http://localhost:8080/usuarios');
//    var request = new http.MultipartRequest("POST", url);
//    request.files.add(http.MultipartFile.fromBytes(
//        'file', _selectedFile,
//        contentType: new MediaType('application', 'octet-stream'),
//        filename: "file_up"));
//    request.send().then((response) {
//      print("test");
//      print(response.statusCode);
//      if (response.statusCode == 200) print("Uploaded!");
//    });

    String token = await getSharedPref("authToken");

    // TODO: permitir subir archivos (List<File> creo) y subir m'ultiples links (List<String>)

    final http.Response response = await http.post(
      'http://localhost:8080/post',
      headers: <String, String>{
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(<String, dynamic>{
        "title": postTitle,
        "description": postDesc,
        "videos": links // TODO; mandar lista de links
      }),
    );

    if (response.statusCode == 200) {
      // post uploaded successfully
      return true;
    } else if (response.statusCode == 500) {
      // bad request
      return false;
    }

  }

  startWebFilePicker() async {
    html.InputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();
    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      final file = files[0];
      final reader = new html.FileReader();
      reader.onLoadEnd.listen((e) {
        _handleResult(reader.result);
      });
      reader.readAsDataUrl(file);
    });

  }

  void InsertVideoLink() {
    showDialog(
        barrierDismissible: false,
        context: context,
        child: new AlertDialog(
          title: new Text("Subir Enlaces"),
          //content: new Text("Hello World"),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: [
                new TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.link),
                    labelText: 'Link del video de YouTube.',
                  ),
                  controller: youtubeLink,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Debe subir un link de YouTube.';
                    } else {
                      // TODO: validar que es un link de youtube
                      return null;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            new FlatButton(
              child: new Text('Aceptar'),
              onPressed: () {
                // TODO: get the link
                Navigator.pop(context);
              },
            ),
          ],
        )
    );
  }

  showAlertDialog(BuildContext context, String title, String message) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed: () { 
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Scaffold(
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
          child: Form(
            autovalidate: true,
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 28),
              child: ListView(
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
                          maxLength: 500,
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
                  Row(
                    children: <Widget>[
//                      Expanded(
//                        child: MaterialButton(
//                          color: Colors.grey,
//                          elevation: 8,
//                          highlightElevation: 2,
//                          shape: RoundedRectangleBorder(
//                              borderRadius: BorderRadius.circular(8)),
//                          textColor: Colors.white,
//                          child: Text('Subir archivo'),
//                          onPressed: () {startWebFilePicker();},
//                        ),
//                      ),
                      Padding(
                        padding: EdgeInsets.all(30.0),
                      ),
                      Expanded(
                        child: MaterialButton(
                          color: Colors.grey,
                          elevation: 8,
                          highlightElevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          textColor: Colors.white,
                          child: Text('Subir Enlace'),
                          onPressed: () {InsertVideoLink();},
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(30.0),
                      ),

                    ],
                  ),
                  Divider(height: 20),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 200,
                      child: Row(
                        children: [
                          MaterialButton(
                            child: Text("Publicar Post"),
                            color: Colors.blue,
                            onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  String _postTitle = postTitle.text;
                                  String _postDesc = postDesc.text;
                                  String _youtubeLink = youtubeLink.text;
                                  List<String> youtubeLinks = List<String>();
                                  // TODO: mandar multiples files y multiples links
                                  youtubeLinks.add(_youtubeLink);
                                  youtubeLinks.add("otro link 1");
                                  youtubeLinks.add("otro link 2");
                                  print("Subiendo Post del Profesor:\nPost Title: $_postTitle\nPost Description: $_postDesc\nYoutube Link(s): $_youtubeLink");
                                  postPost(_postTitle, _postDesc, youtubeLinks).then((success) {
                                    if (success) {
                                      showAlertDialog(context, "Éxito", "El Post fue subido exitósamente.");
                                    } else {
                                      showAlertDialog(context, "Uy No", "El Post no pudo ser subido.");
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
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}