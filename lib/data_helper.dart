import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'product.dart';

class DatabaseHelper{
  //Create Databse instances
  static Database? _database;
  static DatabaseHelper instance = DatabaseHelper._privateConstructer();
  DatabaseHelper._privateConstructer();

  Future<Database> get database async {
    if(_database != null) return _database!;

    //create database
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, "products.db");
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        String sql = "CREATE TABLE products(name TEXT, quantity REAL, price REAL)";
        await db.execute(sql);
      },
      );
      return _database!;
  }
  //insert Record
  Future<int> insertProduct(Product product) async {
    Database db = await instance.database;
    return await db.insert('products', {
      'name' : product.name,
      'quantity' : product.quantity,
      'price' : product.price
      });
  }

  Future<List<Product>> readAllProducts() async {
    Database db = await instance.database;
    final records = await db.query("products");
    return records.map((record) => Product.fromRow(record)).toList();
  }
}