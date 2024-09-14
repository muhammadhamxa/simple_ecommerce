import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_ecommerce/core/base_usecase.dart';
import 'package:simple_ecommerce/core/errors/failures.dart';
import 'package:simple_ecommerce/src/products/domain/entities/product_entity.dart';
import 'package:simple_ecommerce/src/products/domain/usecases/get_product_usecase.dart';
import 'package:simple_ecommerce/src/products/domain/usecases/get_products_usecase.dart';
import 'package:simple_ecommerce/src/products/presentation/bloc/product_bloc.dart';
import 'package:simple_ecommerce/src/products/presentation/bloc/product_events.dart';
import 'package:simple_ecommerce/src/products/presentation/bloc/product_states.dart';

// Mock Classes
class MockGetProducts extends Mock implements GetProducts {}

class MockGetProduct extends Mock implements GetProduct {}

void main() {
  late ProductBloc productBloc;
  late MockGetProducts mockGetProducts;
  late MockGetProduct mockGetProduct;

  setUp(() {
    mockGetProducts = MockGetProducts();
    mockGetProduct = MockGetProduct();
    productBloc = ProductBloc(
      getProducts: mockGetProducts,
      getProduct: mockGetProduct,
    );
  });

  group('ProductBloc', () {
    test('initial state should be ProductInitial', () {
      expect(productBloc.state, equals(ProductInitial()));
    });

    group('LoadProducts', () {
      final products = <Product>[
        const Product(
            id: 1,
            title: 'Product 1',
            price: 10.0,
            image: 'url',
            description: 'testing',
            category: 'testing'),
        const Product(
            id: 2,
            title: 'Product 2',
            price: 20.0,
            image: 'url',
            description: 'testing',
            category: 'testing'),
      ];

      test(
          'should emit ProductLoading and then ProductLoaded when products are fetched successfully',
          () async {
        when(() => mockGetProducts(NoParams()))
            .thenAnswer((_) async => Right(products));

        final expected = [
          ProductLoading(),
          ProductLoaded(products: products),
        ];

        expectLater(productBloc.stream, emitsInOrder(expected));

        productBloc.add(LoadProducts());
      });

      test(
          'should emit ProductLoading and then ProductError when fetching products fails',
          () async {
        when(() => mockGetProducts(NoParams()))
            .thenAnswer((_) async => Left(ServerFailure()));

        final expected = [
          ProductLoading(),
          const ProductError(
              message: 'Oops! Server error occurred. Please try again later.'),
        ];

        expectLater(productBloc.stream, emitsInOrder(expected));

        productBloc.add(LoadProducts());
      });
    });

    group('LoadProduct', () {
      const product = Product(
          id: 1,
          title: 'Product 1',
          price: 10.0,
          image: 'url',
          description: 'testing',
          category: 'testing');

      test(
          'should emit ProductLoading and then ProductLoaded when product is fetched successfully',
          () async {
        when(() => mockGetProduct(const Params(id: 1)))
            .thenAnswer((_) async => const Right(product));

        final expected = [
          ProductLoading(),
          const ProductLoaded(products: [product]),
        ];

        expectLater(productBloc.stream, emitsInOrder(expected));

        productBloc.add(const LoadProduct(1));
      });

      test(
          'should emit ProductLoading and then ProductError when fetching product fails',
          () async {
        when(() => mockGetProduct(const Params(id: 1)))
            .thenAnswer((_) async => Left(ServerFailure()));

        final expected = [
          ProductLoading(),
          const ProductError(
              message: 'Oops! Server error occurred. Please try again later.'),
        ];

        expectLater(productBloc.stream, emitsInOrder(expected));

        productBloc.add(const LoadProduct(1));
      });
    });
  });
}
