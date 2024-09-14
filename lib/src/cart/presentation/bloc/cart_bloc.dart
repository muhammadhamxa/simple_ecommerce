import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/cart_entity.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartLoaded()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartItem>(_onUpdateCartItem);
    on<ClearCart>(_onClearCart);
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final currentState = state;
    log(currentState.toString());
    if (currentState is CartLoaded) {
      try {
        emit(CartLoaded(items: List.from(currentState.items)..add(event.item)));
      } catch (_) {
        emit(CartError());
      }
    }
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final currentState = state;
    if (currentState is CartLoaded) {
      try {
        emit(CartLoaded(
            items: List.from(currentState.items)..remove(event.item)));
      } catch (_) {
        emit(CartError());
      }
    }
  }

  void _onUpdateCartItem(UpdateCartItem event, Emitter<CartState> emit) {
    final currentState = state;
    if (currentState is CartLoaded) {
      try {
        if (event.item.quantity < 0) {
          emit(CartLoaded(
              items: List.from(currentState.items)..remove(event.item)));
        } else {
          emit(CartLoaded(
            items: List.from(currentState.items)
              ..removeWhere((item) => item.product.id == event.item.product.id)
              ..add(event.item),
          ));
        }
      } catch (_) {
        emit(CartError());
      }
    }
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(const CartLoaded(items: []));
  }
}

// In cart_event.dart
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class AddToCart extends CartEvent {
  final CartItem item;

  const AddToCart(this.item);

  @override
  List<Object> get props => [item];
}

class RemoveFromCart extends CartEvent {
  final CartItem item;

  const RemoveFromCart(this.item);

  @override
  List<Object> get props => [item];
}

class UpdateCartItem extends CartEvent {
  final CartItem item;

  const UpdateCartItem(this.item);

  @override
  List<Object> get props => [item];
}

class ClearCart extends CartEvent {}

// In cart_state.dart
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;

  const CartLoaded({this.items = const []});

  double get totalPrice =>
      items.fold(0, (total, current) => total + current.totalPrice);

  @override
  List<Object> get props => [items];
}

class CartUpdated extends CartState {
  final List<CartItem> cart;
  final int itemCount;

  const CartUpdated({required this.cart, required this.itemCount});
}

class CartError extends CartState {}
