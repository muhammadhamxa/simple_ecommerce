import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/base_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repo.dart';

class GetProduct implements UseCase<Product, Params> {
  final ProductRepository repository;

  GetProduct(this.repository);

  @override
  Future<Either<Failure, Product>> call(Params params) async {
    return await repository.getProduct(params.id);
  }
}

class Params extends Equatable {
  final int id;

  const Params({required this.id});

  @override
  List<Object> get props => [id];
}
