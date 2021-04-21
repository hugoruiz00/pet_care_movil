class SelectProduct {
  final int id;
  final String user;
  final int cantidad;

  SelectProduct({this.id, this.user, this.cantidad});

  factory SelectProduct.fromJson(Map<String, dynamic> json) {
    return SelectProduct(
      id: json['id'],
      user: json['name'],
      cantidad: json['lastName'],
    );
  }
}
