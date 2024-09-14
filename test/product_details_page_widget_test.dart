import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_ecommerce/src/products/domain/entities/product_entity.dart';
import 'package:simple_ecommerce/src/products/presentation/pages/product_details_page.dart';

void main() {
  testWidgets('should display product details and add to cart button',
      (WidgetTester tester) async {
    const product = Product(
        id: 1,
        title: 'Product 1',
        price: 10,
        image: 'image_url',
        description: 'testing',
        category: 'widget testing');

    await tester.pumpWidget(
      const MaterialApp(
        home: ProductDetailsPage(product: product),
      ),
    );

    expect(find.text('Product 1'), findsOneWidget);
    expect(find.text('\$10'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
