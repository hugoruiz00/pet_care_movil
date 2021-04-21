import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:petcaremovil/src/models/Product.dart';
import 'package:http/http.dart' as http;
import 'package:petcaremovil/src/pages/Compra.dart';
import 'package:petcaremovil/src/pages/Selecteds.dart';

class Products extends StatelessWidget {
  final String idprofile;

  final String jwt =
      "Bearer eyJhbGciOiJIUzUxMiJ9.eyJqdGkiOiJwZXRKV1QiLCJzdWIiOiIxMkAxMiIsImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdLCJpYXQiOjE2MTkwMjgxNDIsImV4cCI6MTYxOTA0NjE0Mn0.uIQhIKhnndJ73KWOAyVvQNnJBxD6FuvBVMboPR6ggWo82ThAeBycADYtxLyOG74MSRRiQscrGoggpu3OhR-dXw";
  Products({Key keys, @required this.idprofile}) : super(key: keys);

  List<Product> parseListProducts(String reponseBody) {
    final parsed = jsonDecode(reponseBody).cast<Map<String, dynamic>>();
    return parsed.map<Product>((json) => Product.fromJson(json)).toList();
  }

  Future<List<Product>> fetchProducts(http.Client client) async {
    final response = await http.get(
        Uri.http('192.168.0.105:8080', 'API/products'),
        headers: {HttpHeaders.authorizationHeader: jwt});

    return parseListProducts(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Productos"),
        elevation: 0,
        actions: <Widget>[
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
                  builder: (context) => Selecteds(idprofile: "",),
                ),
              );
            },
          )
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: fetchProducts(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? ListProductsClass(listProducts: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ListProductsClass extends StatefulWidget {
  final List<Product> listProducts;
  ListProductsClass({Key keys, @required this.listProducts}) : super(key: keys);
  @override
  ListProducts createState() => ListProducts(listProducts: listProducts);
}

class ListProducts extends State<ListProductsClass> {
  List<Product> listProducts;
  final String jwt =
      "Bearer eyJhbGciOiJIUzUxMiJ9.eyJqdGkiOiJwZXRKV1QiLCJzdWIiOiIxMkAxMiIsImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdLCJpYXQiOjE2MTkwMjgxNDIsImV4cCI6MTYxOTA0NjE0Mn0.uIQhIKhnndJ73KWOAyVvQNnJBxD6FuvBVMboPR6ggWo82ThAeBycADYtxLyOG74MSRRiQscrGoggpu3OhR-dXw";

  ListProducts({Key key, this.listProducts});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.only(left: 30, right: 30),
        child: ListView.builder(
          itemCount: listProducts.length,
          itemBuilder: (BuildContext context, int index) {
            //Uint8List bytes =
            // Base64Decoder().convert(listProducts[index].photo);
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
                          /*Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.stretch, // add this
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                                child: Image.memory(
                                    bytes,
                                    // width: 300,
                                    height: 200,
                                    fit: BoxFit.fill),
                              ),
                            ],
                          ),*/
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 8.0, bottom: 4.0),
                            child: Row(children: <Widget>[
                              Text(
                                listProducts[index].name,
                                //"\$ 1500",
                                style: Theme.of(context).textTheme.headline1,
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.add_shopping_cart_rounded),
                                color: Theme.of(context).secondaryHeaderColor,
                                iconSize: 30,
                                onPressed: () {
                                  addProduct("12@12", listProducts[index].id, 1,
                                          jwt)
                                      .then((value) => {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Selecteds(
                                                  idprofile: "",
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
                                listProducts[index].description,
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
                                  "Precio: " +
                                      listProducts[index].price.toString(),
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
