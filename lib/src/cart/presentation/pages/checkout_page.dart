import 'package:flutter/material.dart';

import '../../../../utils/service_locator.dart';
import '../../domain/entities/cart_entity.dart';
import '../bloc/cart_bloc.dart';

class CheckoutPage extends StatelessWidget {
  final List<CartItem> cartItems;

  const CheckoutPage({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order Summary',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              ...cartItems.map((item) => _buildOrderItem(item)),
              const SizedBox(height: 16),
              Text(
                'Total: \$${_calculateTotal().toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              Text('Shipping Information',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              _buildTextField('Name'),
              _buildTextField('Address'),
              _buildTextField('City'),
              _buildTextField('Country'),
              _buildTextField('Postal Code'),
              const SizedBox(height: 24),
              Text('Payment Information',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              _buildTextField('Card Number'),
              _buildTextField('Expiration Date'),
              _buildTextField('CVV'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Here you would typically process the payment and create the order
                  // For this example, we'll just show a success message and clear the cart
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order placed successfully!')),
                  );
                  sl<CartBloc>().add(ClearCart());
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Place Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItem(CartItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(child: Text(item.product.title)),
          Text('${item.quantity} x \$${item.product.price}'),
        ],
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  double _calculateTotal() {
    return cartItems.fold(
        0, (total, item) => total + (item.product.price * item.quantity));
  }
}
