import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {}

class LoadProduct extends ProductEvent {
  final int productId;

  const LoadProduct(this.productId);

  @override
  List<Object> get props => [productId];
}

class RefreshProducts extends ProductEvent {}
