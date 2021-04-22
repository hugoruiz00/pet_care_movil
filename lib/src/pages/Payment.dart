import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petcaremovil/src/models/InfoPayment.dart';
import 'package:petcaremovil/src/models/Login.dart';
import 'package:petcaremovil/src/pages/Products.dart';
import 'package:petcaremovil/src/pages/Selecteds.dart';

class Payment extends StatefulWidget {
  final Login user;
  Payment({Key keys, @required this.user}) : super(key: keys);
  @override
  State<Payment> createState() => _PaymentState(user: user);
}

class _PaymentState extends State<Payment> {
  final TextEditingController _cntrlrTotal = TextEditingController();

  final Login user;
  _PaymentState({@required this.user});

  Future<InfoPayment> _futureInfo;
  String error = "";
  @override
  void initState() {
    super.initState();
    _futureInfo = getInfoPayment(user.email, user.token);
    _futureInfo.then((value) => {
          _cntrlrTotal.text = value.total.toString(),
        });
  }

  static const values = <String>['Tarjeta', 'Paypal', 'Transferencia'];
  String selectedValue = values.first;

  final selectedColor = Colors.green;
  final unselectedColor = Colors.white;

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
                    builder: (context) => Products(user: user),
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
                    builder: (context) => Selecteds(user: user),
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
                                      buildRadios()
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
      texto = "Agregar productos";
      size = 17.5;
    } else {
      texto = "Realizar pago";
      size = 20.0;
    }
    return ElevatedButton(
      child: Text(
        texto,
        style: TextStyle(fontSize: size),
      ),
      onPressed: () {
        pay(user.email, selectedValue, double.parse(_cntrlrTotal.text),
                user.token)
            .then((value) => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Products(
                      user: user,
                    ),
                  ),
                ));
      },
    );
  }

  Widget buildRadios() => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: unselectedColor,
        ),
        child: Column(
          children: values.map(
            (value) {
              final selected = this.selectedValue == value;
              final color = selected ? selectedColor : unselectedColor;

              return RadioListTile<String>(
                value: value,
                groupValue: selectedValue,
                title: Text(
                  value,
                  style: TextStyle(color: color),
                ),
                activeColor: selectedColor,
                onChanged: (value) =>
                    setState(() => this.selectedValue = value),
              );
            },
          ).toList(),
        ),
      );
}

Future<InfoPayment> getInfoPayment(String user, String token) async {
  final response = await http.get(
    Uri.http('192.168.0.105:8080', 'API/infoPayment/' + user),
    headers: {HttpHeaders.authorizationHeader: token},
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