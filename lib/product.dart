class Product {
  String name;
  double quantity;
  double price;
  
  Product({
    required this.name,
    required this.quantity,
    required this.price
  });

  factory Product.fromRow(Map<String, dynamic> row){
    return Product(
      name: row['name'],
      quantity: row['quantity'],
      price: row['price']);
  }
}