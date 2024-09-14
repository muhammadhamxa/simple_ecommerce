import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/product_entity.dart';
import '../models/product.dart';

abstract class ProductLocalDataSource {
  Future<List<Product>> getLastProducts();
  Future<void> cacheProducts(List<Product> products);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<Product>> getLastProducts() {
    final jsonString = sharedPreferences.getString('CACHED_PRODUCTS');
    if (jsonString != null) {
      return Future.value(json
          .decode(jsonString)
          .map<Product>((json) => ProductModel.fromJson(json))
          .toList());
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheProducts(List<Product> products) {
    return sharedPreferences.setString(
      'CACHED_PRODUCTS',
      json.encode(products
          .map((product) => (product as ProductModel).toJson())
          .toList()),
    );
  }
}

class CacheException implements Exception {}
