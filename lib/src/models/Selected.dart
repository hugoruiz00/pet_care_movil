class Selected {
  int id;
  String nombre;
  int cantidad;
  double subtotal;

  Selected({this.nombre, this.cantidad, this.subtotal, this.id});

  factory Selected.fromJson(Map<String, dynamic> json) {
    return Selected(
        id: json['id'],
        nombre: json['name'],
        cantidad: json['cantidad'],
        subtotal: json['subtotal']);
  }
}
