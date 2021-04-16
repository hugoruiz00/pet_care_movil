/*class Venta {
  final int id;
  final int idOwner;
  final String metodopago;
  final int total;
  final String fecha;

  Venta({this.id, this.idOwner, this.metodopago, this.total, this.fecha});

  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      id: json['id'],
      idOwner: json['owner_id'],
      metodopago: json['metodopago'],
      total: json['total'],
      fecha: json['fecha'],
    );
  }
}*/

class Venta {
  final int id;
  final String name;
  final String lastName;
  final String phone;
  final String address;
  final int user;
  final String email;

  Venta(
      {this.id,
      this.name,
      this.lastName,
      this.phone,
      this.address,
      this.user,
      this.email});

  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      id: json['id'],
      name: json['name'],
      lastName: json['lastName'],
      phone: json['phone'],
      address: json['address'],
      user: json['user'],
      email: json['email'],
    );
  }
}
