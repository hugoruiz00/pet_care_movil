import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:app-pet-care/src/models/Login.dart';

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

    String url = '192.168.1.69:8080';

    Map<String, String> params = {"user": user, "password": password};

    Map<String, String> header = {
      HttpHeaders.contentTypeHeader: "application/json",
    };

    Uri uri = Uri.http(url, 'user');
    print(uri);
    print(header);
    print(jsonEncode(params));
    final response = await http.post(uri,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonEncode(params));

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      login.add(Login(jsonData['token'], jsonData['user']));
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
          //child: Image.asset("assets/iconoLogin.png", width: 170, height: 170),
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
                      if (value == null)
                        {
                          print("ERROR - Revise los datos ingresados"),
                        }
                      else
                        {
                          print("OK - Inicio de sesion correcto"),
                          print("Token user: "),
                          print(value[0].token),
                          loginD = Login(
                            value[0].token,
                            value[0].email,
                          ),
                        }
                    });
              },
            )),
        Container(
            padding: EdgeInsets.all(30),
            child: Row(
              children: <Widget>[
                Text('¿No tienes una cuenta?', style: TextStyle(fontSize: 14)),
                FlatButton(
                  textColor: Colors.blue,
                  child: Text(
                    'Registrate',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    print("Regístrate");
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ))
      ],
    )));
  }
}

class Login {
  String token;
  String email;

  Login(String token, String email) {
    this.token = token;
    this.email = email;
  }
}
