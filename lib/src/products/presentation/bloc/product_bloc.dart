import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/get_product_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'product_events.dart';
import 'product_states.dart';

class ProductBloc extends Bloc<ProductEvent, ProductBlocStates> {
  final GetProducts getProducts;
  final GetProduct getProduct;

  ProductBloc({required this.getProducts, required this.getProduct})
      : super(ProductInitial()) {
    on<LoadProducts>((event, emit) async {
      emit(ProductLoading());
      final failureOrProducts = await getProducts(NoParams());
      emit(failureOrProducts.fold(
        (failure) => ProductError(message: _mapFailureToMessage(failure)),
        (products) => ProductLoaded(products: products),
      ));
    });

    on<LoadProduct>((event, emit) async {
      emit(ProductLoading());
      final failureOrProduct = await getProduct(Params(id: event.productId));
      emit(failureOrProduct.fold(
        (failure) => ProductError(message: _mapFailureToMessage(failure)),
        (product) => ProductLoaded(products: [product]),
      ));
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return 'Oops! Server error occurred. Please try again later.';
      case NetworkFailure _:
        return 'No internet connection. Please check your network settings.';
      case CacheFailure _:
        return 'Failed to load cached data. Please refresh or try again.';
      case InvalidInputFailure _:
        return (failure as InvalidInputFailure).message;
      default:
        return 'Unexpected error occurred. Please try again.';
    }
  }
}
