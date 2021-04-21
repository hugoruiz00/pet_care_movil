class Selected{
  String nombre;
  int cantidad;
  double subtotal;

  Selected({this.nombre, this.cantidad, this.subtotal});

  factory Selected.fromJson(Map<String, dynamic> json) {
    return Selected(
        nombre: json['name'],
        cantidad: json['cantidad'],
        subtotal: json['subtotal']);
  }
}
