class VentaDetalle {
  final int id;
  final String producto;
  final int cantidad;
  final double precio;
  final double subtotal;

  VentaDetalle({
    this.id,
    this.producto,
    this.cantidad,
    this.precio,
    this.subtotal,
  });

  factory VentaDetalle.fromJson(Map<String, dynamic> json) {
    return VentaDetalle(
      id: json['id'],
      producto: json['producto'],
      cantidad: json['cantidad'],
      precio: json['precio'],
      subtotal: json['subtotal'],
    );
  }
}
