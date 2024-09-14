import 'package:flutter/material.dart';

import '../../../../utils/service_locator.dart';
import '../../../cart/domain/entities/cart_entity.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../domain/entities/product_entity.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                product.image,
                height: 250,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title,
                      style: Theme.of(context).textTheme.headlineSmall),
                  Text('\$${product.price}',
                      style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 16),
                  Text(product.description),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      sl<CartBloc>().add(
                          AddToCart(CartItem(product: product, quantity: 1)));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to cart')),
                      );
                    },
                    child: const Text('Add to Cart'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
