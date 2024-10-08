import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);
}

class ServerFailure extends Failure {
  @override
  List<Object> get props => [];
}

class CacheFailure extends Failure {
  @override
  List<Object> get props => [];
}

class NetworkFailure extends Failure {
  @override
  List<Object> get props => [];
}

class InvalidInputFailure extends Failure {
  final String message;

  const InvalidInputFailure(this.message);

  @override
  List<Object> get props => [message];
}
