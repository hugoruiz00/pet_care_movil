class InfoPayment {
  final double total;
  final int cantidad;
  final bool isExistente;

  InfoPayment({this.total, this.cantidad, this.isExistente});

  factory InfoPayment.fromJson(Map<String, dynamic> json) {
    return InfoPayment(
        total: json['total'],
        cantidad: json['cantidad'],
        isExistente: json['isExistente']);
  }
}
