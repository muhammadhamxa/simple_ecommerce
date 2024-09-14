import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_ecommerce/src/cart/domain/entities/cart_entity.dart';
import 'package:simple_ecommerce/src/cart/presentation/bloc/cart_bloc.dart';

class MockCartItem extends Mock implements CartItem {}

void main() {
  late CartBloc cartBloc;

  setUp(() {
    cartBloc = CartBloc();
  });

  group('CartBloc', () {
    test('should emit CartLoaded when AddToCart event is added', () {
      final cartItem = MockCartItem();
      final expectedState = CartLoaded(items: [cartItem]);

      cartBloc.add(AddToCart(cartItem));
      expectLater(
          cartBloc.stream,
          emitsInOrder([
            CartLoaded(items: [cartItem])
          ]));
    });

    test(
        'should emit CartLoaded with updated items when UpdateCartItem event is added',
        () {
      final cartItem = MockCartItem();
      final updatedCartItem = cartItem.copyWith(quantity: 2);
      final expectedState = CartLoaded(items: [updatedCartItem]);

      cartBloc.add(AddToCart(cartItem));
      cartBloc.add(UpdateCartItem(updatedCartItem));

      expectLater(
          cartBloc.stream,
          emitsInOrder([
            CartLoaded(items: [updatedCartItem])
          ]));
    });

    test(
        'should emit CartLoaded with items removed when RemoveFromCart event is added',
        () {
      final cartItem = MockCartItem();
      cartBloc.add(AddToCart(cartItem));
      cartBloc.add(RemoveFromCart(cartItem));

      expectLater(cartBloc.stream, emitsInOrder([const CartLoaded(items: [])]));
    });

    test(
        'should emit CartLoaded with empty items when ClearCart event is added',
        () {
      final cartItem = MockCartItem();
      cartBloc.add(AddToCart(cartItem));
      cartBloc.add(ClearCart());

      expectLater(cartBloc.stream, emitsInOrder([const CartLoaded(items: [])]));
    });
  });
}
