class Product {
  final int id;
  final String name;
  final double price;
  final int existence;
  final String description;
  final String photo;

  Product({this.id, this.name, this.price, this.existence, this.description, this.photo});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      existence: json['existence'],
      description: json['description'],
      photo: json['photo']
    );
  }
}
