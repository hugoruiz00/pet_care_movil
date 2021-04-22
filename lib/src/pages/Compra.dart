import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:petcaremovil/src/models/venta.dart';

class Compra extends StatelessWidget {
  final String idcompra;

  Compra({Key keys, @required this.idcompra}) : super(key: keys);

  List<Venta> parseListProductos(String reponseBody) {
    final parsed = jsonDecode(reponseBody).cast<Map<String, dynamic>>();
    return parsed.map<Venta>((json) => Venta.fromJson(json)).toList();
  }

  Future<List<Venta>> fetchDetalles(http.Client client) async {
    final response = await http
        .get(Uri.parse('http://192.168.56.1:8080/API/$idcompra'), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Token cbb26288d097255ebf4e4a02339ad53561e64c40"
    });
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
      body: FutureBuilder<List<Venta>>(
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
  final List<Venta> listCompras;

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
                          //listCompras[index].name, producto
                          "Mi producto",
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Spacer(),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 5.0),
                      child: Row(children: <Widget>[
                        Text(
                            //"${DateFormat('dd/MM/yyyy').format(trip.startDate).toString()} - ${DateFormat('dd/MM/yyyy').format(trip.endDate).toString()}"),
                            "Cantidad : 50",
                            style: Theme.of(context).textTheme.bodyText1),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Row(
                        children: <Widget>[
                          Text("Precio \$15.50",
                              style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Subtotal \$2500.50",
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
