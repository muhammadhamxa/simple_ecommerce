import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/service_locator.dart';
import '../../domain/entities/cart_entity.dart';
import '../bloc/cart_bloc.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: BlocBuilder<CartBloc, CartState>(
        bloc: sl<CartBloc>(),
        builder: (context, state) {
          log(state.toString());
          if (state is CartLoaded) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      return _buildCartItem(context, state.items[index]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'Total: \$${state.totalPrice.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (state.items.isNotEmpty) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) =>
                                    CheckoutPage(cartItems: state.items)));
                          } else {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text('Your cart is empty'),
                                ),
                              );
                          }
                        },
                        child: const Text('Proceed to Checkout'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is CartError) {
            return const Center(child: Text('An error occurred'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item) {
    return ListTile(
      leading: Image.network(item.product.image, width: 50, height: 50),
      title: Text(item.product.title),
      subtitle: Text('\$${item.product.price} x ${item.quantity}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              sl<CartBloc>().add(UpdateCartItem(
                item.copyWith(quantity: item.quantity - 1),
              ));
            },
          ),
          Text('${item.quantity}'),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              sl<CartBloc>().add(UpdateCartItem(
                item.copyWith(quantity: item.quantity + 1),
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              sl<CartBloc>().add(RemoveFromCart(item));
            },
          ),
        ],
      ),
    );
  }
}
