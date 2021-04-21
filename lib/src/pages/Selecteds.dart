import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petcaremovil/src/models/Selected.dart';
import 'package:petcaremovil/src/pages/Compra.dart';
import 'package:petcaremovil/src/pages/Payment.dart';
import 'package:petcaremovil/src/pages/Products.dart';

class Selecteds extends StatelessWidget {
  final String idprofile;

  final String jwt =
      "Bearer eyJhbGciOiJIUzUxMiJ9.eyJqdGkiOiJwZXRKV1QiLCJzdWIiOiIxMkAxMiIsImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdLCJpYXQiOjE2MTkwMjgxNDIsImV4cCI6MTYxOTA0NjE0Mn0.uIQhIKhnndJ73KWOAyVvQNnJBxD6FuvBVMboPR6ggWo82ThAeBycADYtxLyOG74MSRRiQscrGoggpu3OhR-dXw";
  Selecteds({Key keys, @required this.idprofile}) : super(key: keys);

  List<Selected> parseListSelecteds(String reponseBody) {
    final parsed = jsonDecode(reponseBody).cast<Map<String, dynamic>>();
    return parsed.map<Selected>((json) => Selected.fromJson(json)).toList();
  }

  Future<List<Selected>> fetchSelecteds(http.Client client) async {
    final response = await http.get(
        Uri.http('192.168.0.105:8080', 'API/selecteds/12@12'),
        headers: {HttpHeaders.authorizationHeader: jwt});

    return parseListSelecteds(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Agregados al carrito"),
        elevation: 0,
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
              Icons.monetization_on,
              color: Colors.white,
              size: 32,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Payment(
                    idprofile: "",
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Selected>>(
        future: fetchSelecteds(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? ListSelectedsClass(listSelecteds: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ListSelectedsClass extends StatefulWidget {
  final List<Selected> listSelecteds;
  ListSelectedsClass({Key keys, @required this.listSelecteds})
      : super(key: keys);
  @override
  ListSelecteds createState() => ListSelecteds(listSelecteds: listSelecteds);
}

class ListSelecteds extends State<ListSelectedsClass> {
  List<Selected> listSelecteds;
  final String jwt =
      "Bearer eyJhbGciOiJIUzUxMiJ9.eyJqdGkiOiJwZXRKV1QiLCJzdWIiOiIxMkAxMiIsImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdLCJpYXQiOjE2MTkwMTAwNzksImV4cCI6MTYxOTAyODA3OX0.CViRxBIjJ2c_r32o4md7E7odVvpuLRJZDPWV-HuBjfvwjkMmnL-duM8TzwiCEjquEmijdelcKh1DpCMi6unFKg";

  ListSelecteds({Key key, this.listSelecteds});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.only(left: 30, right: 30),
        child: ListView.builder(
          itemCount: listSelecteds.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: EdgeInsets.only(bottom: 20),
                child: Card(
                  color: Theme.of(context).cardColor,
                  shadowColor: Colors.blueAccent,
                  elevation: 4,
                  child: new InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 8.0, bottom: 4.0),
                            child: Row(children: <Widget>[
                              Text(
                                listSelecteds[index].nombre,
                                //"\$ 1500",
                                style: Theme.of(context).textTheme.headline1,
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.delete),
                                color: Theme.of(context).secondaryHeaderColor,
                                iconSize: 30,
                                onPressed: () {
                                  addProduct("12@12",
                                          listSelecteds[index].cantidad, 1, jwt)
                                      .then((value) => {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Compra(
                                                  idcompra: "17",
                                                ),
                                              ),
                                            )
                                          });
                                },
                              )
                            ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, top: 4.0, bottom: 10.0),
                            child: Row(children: <Widget>[
                              Text(
                                //"${DateFormat('dd/MM/yyyy').format(trip.startDate).toString()} - ${DateFormat('dd/MM/yyyy').format(trip.endDate).toString()}"),
                                listSelecteds[index].cantidad.toString(),
                                //"12-05-2020",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 8.0, bottom: 8.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Subtotal: " +
                                      listSelecteds[index].subtotal.toString(),
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
          },
        ));
  }
}

Future<String> addProduct(
    String user, int id, int cantidad, String token) async {
  Map<String, dynamic> params = {'user': user, 'id': id, 'cantidad': cantidad};

  final response = await http.post(
    Uri.http('192.168.0.105:8080', 'API/addProduct'),
    headers: {
      HttpHeaders.authorizationHeader: token,
      HttpHeaders.contentTypeHeader: "application/json",
    },
    body: jsonEncode(params),
  );
  print(response.statusCode);
  if (response.statusCode == 200) {
    return "ok";
  } else {
    return "ok";
  }
}
