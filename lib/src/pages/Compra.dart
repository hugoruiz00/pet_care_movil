import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:petcaremovil/src/models/Login.dart';
import 'package:petcaremovil/src/models/VentaDetalle.dart';

class Compra extends StatelessWidget {
  final String idcompra;
  final Login user;
  Compra({Key keys, @required this.idcompra, this.user}) : super(key: keys);

  List<VentaDetalle> parseListProductos(String reponseBody) {
    print(reponseBody+" AAAAAAAAAAAA");
    final parsed = jsonDecode(reponseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<VentaDetalle>((json) => VentaDetalle.fromJson(json))
        .toList();
  }

  Future<List<VentaDetalle>> fetchDetalles(http.Client client) async {
    final response = await http.get(
        Uri.http('192.168.0.105:8080', 'API/compraDetalle/$idcompra'),
        headers: {HttpHeaders.authorizationHeader: user.token});
    return parseListProductos(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Detalles de la Compra"),
        elevation: 0,
      ),
      body: FutureBuilder<List<VentaDetalle>>(
        future: fetchDetalles(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? ListDetalles(listCompras: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ListDetalles extends StatelessWidget {
  final List<VentaDetalle> listCompras;

  ListDetalles({Key key, this.listCompras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).backgroundColor,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: listCompras.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 3,
              shadowColor: Theme.of(context).accentColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
                      child: Row(children: <Widget>[
                        Text(
                          listCompras[index].producto,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Spacer(),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 5.0),
                      child: Row(children: <Widget>[
                        Text("Cantidad : ${listCompras[index].cantidad}",
                            style: Theme.of(context).textTheme.bodyText1),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Row(
                        children: <Widget>[
                          Text("Precio \$ ${listCompras[index].precio}",
                              style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Subtotal: \$ ${listCompras[index].subtotal}",
                            style: new TextStyle(
                                fontSize: 18.0, color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
