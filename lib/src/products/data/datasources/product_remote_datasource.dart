import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:simple_ecommerce/src/products/data/models/product.dart';

import '../../domain/entities/product_entity.dart';

abstract class ProductRemoteDataSource {
  Future<List<Product>> getProducts();
  Future<Product> getProduct(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ProductRemoteDataSourceImpl({required this.client, required this.baseUrl});

  @override
  Future<List<Product>> getProducts() async {
    final response = await client.get(Uri.parse('$baseUrl/products'));

    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> productsJson = json.decode(response.body);
      return productsJson.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Future<Product> getProduct(int id) async {
    final response = await client.get(Uri.parse('$baseUrl/products/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> productJson = json.decode(response.body);
      return ProductModel.fromJson(productJson);
    } else {
      throw Exception('Failed to load product');
    }
  }
}
