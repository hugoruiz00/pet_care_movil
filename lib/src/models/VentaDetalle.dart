class VentaDetalle {
  final int id;
  final int ventaid;
  final int productoid;
  final int cantidad;
  final int precio;
  final int subtotal;

  VentaDetalle({
    this.id,
    this.ventaid,
    this.productoid,
    this.cantidad,
    this.precio,
    this.subtotal,
  });

  factory VentaDetalle.fromJson(Map<String, dynamic> json) {
    return VentaDetalle(
      id: json['id'],
      ventaid: json['venta_id'],
      productoid: json['producto_id'],
      cantidad: json['cantidad'],
      precio: json['precio'],
      subtotal: json['subtotal'],
    );
  }
}
