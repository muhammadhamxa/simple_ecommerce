import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_ecommerce/src/products/presentation/pages/product_details_page.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/service_locator.dart';
import '../../../cart/domain/entities/cart_entity.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_states.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: const [
          CartIcon(),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductBlocStates>(
        bloc: sl<ProductBloc>(),
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) =>
                              ProductDetailsPage(product: product),
                        ),
                      );
                    },
                    leading: Image.network(
                      product.image,
                      width: 40,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    tileColor: tileColor,
                    title: Text(product.title),
                    subtitle: Text('\$${product.price}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.add, color: blackColor),
                      onPressed: () {
                        sl<CartBloc>().add(
                          AddToCart(
                            CartItem(
                              product: product,
                              quantity: 1,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          } else if (state is ProductError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}

class CartIcon extends StatelessWidget {
  const CartIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: sl<CartBloc>(),
        builder: (context, state) {
          int itemCount = 0;
          if (state is CartUpdated) {
            itemCount = state.itemCount;
          }
          return IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            icon: Stack(
              children: [
                const Icon(
                  Icons.shopping_cart,
                  color: cartIconColor,
                  size: 32,
                ),
                if (itemCount > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$itemCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const CartPage(),
                ),
              );
            },
          );
        });
  }
}
