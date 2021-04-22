class Venta {
  final int id;
  final int idOwner;
  final String metodopago;
  final double total;
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
}
