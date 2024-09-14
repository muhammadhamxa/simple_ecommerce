import 'package:equatable/equatable.dart';

import '../../domain/entities/product_entity.dart';

abstract class ProductBlocStates extends Equatable {
  const ProductBlocStates();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductBlocStates {}

class ProductLoading extends ProductBlocStates {}

class ProductLoaded extends ProductBlocStates {
  final List<Product> products;

  const ProductLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class ProductError extends ProductBlocStates {
  final String message;

  const ProductError({required this.message});

  @override
  List<Object> get props => [message];
}
