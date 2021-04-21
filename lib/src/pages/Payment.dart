import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petcaremovil/src/models/InfoPayment.dart';
import 'package:petcaremovil/src/pages/Products.dart';
import 'package:petcaremovil/src/pages/Selecteds.dart';

class Payment extends StatefulWidget {
  final String idprofile;
  Payment({Key keys, @required this.idprofile}) : super(key: keys);
  @override
  State<Payment> createState() => _PaymentState(idprofile: idprofile);
}

class _PaymentState extends State<Payment> {
  final String jwt =
      "Bearer eyJhbGciOiJIUzUxMiJ9.eyJqdGkiOiJwZXRKV1QiLCJzdWIiOiIxMkAxMiIsImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdLCJpYXQiOjE2MTkwMjgxNDIsImV4cCI6MTYxOTA0NjE0Mn0.uIQhIKhnndJ73KWOAyVvQNnJBxD6FuvBVMboPR6ggWo82ThAeBycADYtxLyOG74MSRRiQscrGoggpu3OhR-dXw";

  final TextEditingController _cntrlrMetodoPago = TextEditingController();
  final TextEditingController _cntrlrTotal = TextEditingController();
  final TextEditingController _cntrlrUsername = TextEditingController();

  final String idprofile;
  _PaymentState({@required this.idprofile});

  Future<InfoPayment> _futureInfo;
  String error = "";
  @override
  void initState() {
    super.initState();
    _futureInfo = getInfoPayment(jwt);
    this._cntrlrMetodoPago.text = "tarjetaa";
    this._cntrlrTotal.text = 100.0.toString();
    this._cntrlrUsername.text = "12@12";
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Pago'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add_shopping_cart_sharp,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Products(
                      idprofile: "",
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Selecteds(
                      idprofile: "",
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<InfoPayment>(
            future: _futureInfo,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Container(
                      color: Theme.of(context).backgroundColor,
                      padding: EdgeInsets.only(bottom: 650),
                      child: Card(
                        color: Theme.of(context).cardColor,
                        shadowColor: Colors.blueAccent,
                        elevation: 4,
                        child: InkWell(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 50.0, top: 40.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 8.0, bottom: 4.0),
                                  child: Center(
                                      child: Column(
                                    children: [
                                      Text(
                                        "Seleccione un método de pago",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white),
                                      ),
                                    ],
                                  )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 60.0, bottom: 10.0),
                                  child: Center(
                                    child: Text(
                                      snapshot.data.cantidad.toString() +
                                          " productos",
                                      style:
                                          Theme.of(context).textTheme.headline3,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 8.0, bottom: 8.0),
                                  child: Center(
                                    child: Text(
                                      "Total: " +
                                          snapshot.data.total.toString(),
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 20.0, bottom: 8.0),
                                  child: Center(
                                    child: _btnPay(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ));
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
              }

              return CircularProgressIndicator();
            },
          ),
        ));
  }

  _btnPay() {
    String texto = "";
    double size = 0.0;
    if (_cntrlrTotal.text == "0.0") {
      texto = "Realizar pago";
      size = 20.0;
    } else {
      texto = "Agregar productos";
      size = 17.5;
    }
    return ElevatedButton(
      child: Text(
        texto,
        style: TextStyle(fontSize: size),
      ),
      onPressed: () {
        pay(_cntrlrUsername.text, _cntrlrMetodoPago.text,
                double.parse(_cntrlrTotal.text), jwt)
            .then((value) => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Products(
                      idprofile: "",
                    ),
                  ),
                ));
      },
    );
  }
}

Future<InfoPayment> getInfoPayment(String jwt) async {
  final response = await http.get(
    Uri.http('192.168.0.105:8080', 'API/infoPayment/12@12'),
    headers: {HttpHeaders.authorizationHeader: jwt},
  );
  print(response.statusCode);
  if (response.statusCode == 200) {
    return InfoPayment.fromJson(jsonDecode(response.body));
  } else {
    print("Failed to get info " + response.body);
  }
}

Future<String> pay(
    String username, String metodoPago, double total, String jwt) async {
  final http.Response response = await http.post(
    Uri.http('192.168.0.105:8080', 'API/pay'),
    headers: {
      HttpHeaders.authorizationHeader: jwt,
      HttpHeaders.contentTypeHeader: "application/json",
    },
    body: jsonEncode(<String, dynamic>{
      'username': username,
      'metodoPago': metodoPago,
      'total': total,
    }),
  );

  if (response.statusCode == 200) {
    return "Pago realizado";
  } else {
    print("Failed pay " + response.body);
  }
}
