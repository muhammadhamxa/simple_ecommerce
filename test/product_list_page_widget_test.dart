import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_ecommerce/src/cart/presentation/bloc/cart_bloc.dart';
import 'package:simple_ecommerce/src/products/domain/entities/product_entity.dart';
import 'package:simple_ecommerce/src/products/presentation/pages/product_list_page.dart';

class MockCartBloc extends Mock implements CartBloc {}

void main() {
  late CartBloc cartBloc;

  setUp(() {
    cartBloc = MockCartBloc();
  });

  testWidgets('should display list of products', (WidgetTester tester) async {
    final products = [
      const Product(
          id: 1,
          title: 'Product 1',
          price: 10,
          image: 'image_url',
          description: 'testing',
          category: 'testing'),
      const Product(
          id: 2,
          title: 'Product 2',
          price: 20,
          image: 'image_url',
          description: 'testing',
          category: 'testing'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CartBloc>.value(
          value: cartBloc,
          child: const ProductListPage(),
        ),
      ),
    );

    expect(find.text('Product 1'), findsOneWidget);
    expect(find.text('Product 2'), findsOneWidget);
  });

  testWidgets('should add product to cart when Add button is pressed',
      (WidgetTester tester) async {
    const product = Product(
        id: 1,
        title: 'Product 1',
        price: 10,
        image: 'image_url',
        description: 'testing',
        category: 'testing');
    when(() => cartBloc.add(any())).thenReturn(null);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CartBloc>.value(
          value: cartBloc,
          child: const ProductListPage(),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.add));
    verify(() => cartBloc.add(AddToCart(any()))).called(1);
  });
}
