import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:petcaremovil/src/models/Login.dart';

import 'package:petcaremovil/src/models/venta.dart';
import 'package:petcaremovil/src/pages/Compra.dart';
import 'package:petcaremovil/src/pages/Payment.dart';
import 'package:petcaremovil/src/pages/Products.dart';

class ListaCompras extends StatelessWidget {
  final Login user;

  ListaCompras({Key keys, @required this.user}) : super(key: keys);

  List<Venta> parseListVentas(String reponseBody) {
    final parsed = jsonDecode(reponseBody).cast<Map<String, dynamic>>();
    return parsed.map<Venta>((json) => Venta.fromJson(json)).toList();
  }

  Future<List<Venta>> fetchCompras(http.Client client) async {
    final response = await http.get(
        Uri.http('192.168.0.102:8080', 'API/compras/' + user.id.toString()),
        headers: {HttpHeaders.authorizationHeader: user.token});
    print("---->" + response.body);
    return parseListVentas(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Mis Compras Realizadas"),
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
                    user: user,
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
                    user: user,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Venta>>(
        future: fetchCompras(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? ListCompras(
                  listCompras: snapshot.data,
                  user: user,
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ListCompras extends StatelessWidget {
  final List<Venta> listCompras;
  final Login user;

  ListCompras({Key key, this.listCompras, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.only(left: 30, right: 30),
        child: ListView.builder(
          itemCount: listCompras.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: EdgeInsets.only(bottom: 20),
                child: Card(
                  color: Theme.of(context).cardColor,
                  shadowColor: Colors.blueAccent,
                  elevation: 4,
                  child: new InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Compra(
                            idcompra: listCompras[index].id.toString(),
                            user: user,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 8.0, bottom: 4.0),
                            child: Row(children: <Widget>[
                              Text(
                                "\$ ${listCompras[index].total}",
                                style: Theme.of(context).textTheme.headline1,
                              ),
                              Spacer(),
                              Icon(
                                Icons.shopping_bag_outlined,
                                color: Theme.of(context).secondaryHeaderColor,
                              )
                            ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, top: 4.0, bottom: 10.0),
                            child: Row(children: <Widget>[
                              Text(
                                //"${DateFormat('dd/MM/yyyy').format(trip.startDate).toString()} - ${DateFormat('dd/MM/yyyy').format(trip.endDate).toString()}"),
                                listCompras[index].fecha,
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
                                  listCompras[index].metodopago,
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
