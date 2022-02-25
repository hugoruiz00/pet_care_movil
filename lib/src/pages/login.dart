import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:app-pet-care/src/models/Login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:petcaremovil/src/models/Login.dart';
import 'package:petcaremovil/src/pages/Products.dart';
import 'package:url_launcher/url_launcher.dart';


class LoginPage extends StatefulWidget {
  // Initially password is obscure
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<LoginPage> {
  Future<List<Login>> loginFinal;
  Login loginD;

  Future<List<Login>> postLogin(String user, String password) async {
    List<Login> login = [];

    String url = '192.168.0.102:8080';

    Map<String, String> params = {"user": user, "password": password};

    Map<String, String> header = {
      HttpHeaders.contentTypeHeader: "application/json",
    };

    Uri uri = Uri.http(url, 'user', params);
    print(uri);
    print(header);
    print(jsonEncode(params));
    final response = await http.post(uri, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
    });

    print(response.bodyBytes.length);

    if (response.statusCode == 200 && response.bodyBytes.length != 0) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      login.add(Login(jsonData['id'], jsonData['token'], jsonData['user']));
      return login;
    } else {
      var response1 = response.body;
      print("ERROR DE LOGIN $response1");
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool hidePassword = true;
  bool isApiCallProcess = false;
  @override
  void initState() {
    super.initState();
    //loginFinal = postLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*appBar: AppBar(
              title: Text('Login Screen App'),
            ),*/
        body: SingleChildScrollView(
            child: Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(60, 100, 60, 40),
          child: Image.asset("assets/iconoLogin.png", width: 170, height: 170),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(60, 10, 60, 20),
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              labelText: 'Usuario',
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
          child: TextField(
            obscureText: hidePassword,
            controller: passwordController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              labelText: 'Contraseña',
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                color: Theme.of(context).accentColor.withOpacity(0.9),
                icon: Icon(
                    hidePassword ? Icons.visibility_off : Icons.visibility),
              ),
            ),
          ),
        ),
        FlatButton(
          onPressed: () {
            //forgot password screen
          },
          textColor: Colors.blue,
          //child: Text('Forgot Password'),
        ),
        Container(
            height: 50,
            width: 310,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: RaisedButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0)),
              textColor: Colors.white,
              color: Colors.blue,
              child: Text('Iniciar sesión', style: TextStyle(fontSize: 18)),
              onPressed: () {
                print(nameController.text);
                print(passwordController.text);
                loginFinal =
                    postLogin(nameController.text, passwordController.text);
                loginFinal.then((value) => {
                      //TODO
                      if (value == null)
                        {
                          print("ERROR - Revise los datos ingresados"),
                          Fluttertoast.showToast(
                              msg: 'Revise los datos ingresados',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 20.0)
                        }
                      else
                        {
                          print("OK - Inicio de sesion correcto"),
                          print("Token user: "),
                          print(value[0].token),
                          loginD = Login(
                            value[0].id,
                            value[0].token,
                            value[0].email,
                          ),
                          Fluttertoast.showToast(
                              msg: 'Inicio de sesión correcto',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 20.0),
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Products(
                                      user: this.loginD,
                                    )),
                          ),
                        }
                    });
              },
            )),
        Container(
            padding: EdgeInsets.all(30),
            child: Row(
              children: <Widget>[
                Text('¿No sabe cómo usar la app?', style: TextStyle(fontSize: 14)),
                FlatButton(
                  textColor: Colors.blue,
                  child: Text(
                    'Ver manual',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    print("Ver manual");
                    launch("https://drive.google.com/drive/u/1/folders/1uRk8S7E3rAXKAVPY1Us-W6xzytI-93-8");
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ))
      ],
    )));
  }
}
