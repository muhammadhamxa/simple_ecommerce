import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_ecommerce/src/cart/domain/entities/cart_entity.dart';
import 'package:simple_ecommerce/src/cart/presentation/bloc/cart_bloc.dart';
import 'package:simple_ecommerce/src/cart/presentation/pages/cart_page.dart';
import 'package:simple_ecommerce/src/products/domain/entities/product_entity.dart';

class MockCartBloc extends Mock implements CartBloc {}

void main() {
  late CartBloc cartBloc;

  setUp(() {
    cartBloc = MockCartBloc();
  });

  testWidgets('should display cart items and total price',
      (WidgetTester tester) async {
    const cartItem = CartItem(
      product: Product(
          id: 1,
          title: 'Product 1',
          price: 10,
          image: '',
          description: 'testing',
          category: 'testing'),
      quantity: 1,
    );
    const cartLoadedState = CartLoaded(items: [cartItem]);

    when(() => cartBloc.state).thenReturn(cartLoadedState);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CartBloc>.value(
          value: cartBloc,
          child: const CartPage(),
        ),
      ),
    );

    expect(find.text('Product 1'), findsOneWidget);
    expect(find.text('\$10 x 1'), findsOneWidget);
    expect(find.text('Total: \$10.00'), findsOneWidget);
  });
}
