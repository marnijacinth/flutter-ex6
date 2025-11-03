import 'package:flutter/material.dart';
import 'product.dart';
import 'data_helper.dart';
void main() {
  runApp(MaterialApp(
    title: "Product Inventory",
    home: ProductsApp(),
  ));
}

class ProductsApp extends StatefulWidget {
  const ProductsApp({super.key});

  @override
  State<ProductsApp> createState() => _ProductsAppState();
}

class _ProductsAppState extends State<ProductsApp> {
  final _formkey = GlobalKey<FormState>();
  final _namecontroller = TextEditingController();
  final _quantitycontroller = TextEditingController();
  final _pricecontroller = TextEditingController();
  List<Product> _products = [];

  void _showAllProducts() async {
    final products = await DatabaseHelper.instance.readAllProducts();
    setState(() {
      _products = products;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products Info"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Form(
          key: _formkey,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                TextFormField(
                  controller: _namecontroller,
                  decoration: InputDecoration(
                      labelText: "Enter Product name",
                      border: OutlineInputBorder()
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "Enter Product name";
                    }
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _quantitycontroller,
                  decoration: InputDecoration(
                      labelText: "Enter Quantity",
                      border: OutlineInputBorder()
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return "Enter Quantity";
                    }
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _pricecontroller,
                  decoration: InputDecoration(
                      labelText: "Enter price",
                      border: OutlineInputBorder()
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "Enter price";
                    }
                  },
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white
                    ),
                    onPressed: () async {
                      if(_formkey.currentState!.validate()){
                        String name = _namecontroller.text;
                        double quantity = double.parse(_quantitycontroller.text);
                        double price = double.parse(_pricecontroller.text);

                        //Create Product object
                        Product product = Product(name: name, quantity: quantity, price: price);
                        await DatabaseHelper.instance.insertProduct(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Product Details Saved"))
                        );
                        _showAllProducts();
                      }
                    },
                    child: Text("Save Details")),
                Expanded(
                    child: ListView.builder(
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(product.name[0]),
                          ),
                          title: Text(product.name),
                          subtitle: Text("Quantity: ${product.quantity.toString()}, Price: ${product.price}"),
                        );
                      },
                    )
                )
              ],
            ),
          )),
    );
  }
}