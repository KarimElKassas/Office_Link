import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_guid/flutter_guid.dart';
import '../error/failure.dart';

abstract class BaseUseCase<T, Parameters>{
  Future<Either<Failure, T>> call(Parameters parameters);
}

class NoParameters extends Equatable {
  const NoParameters();
  @override
  List<Object> get props => [];
}

class OnlyTokenParameters {
  final String token;

  OnlyTokenParameters(this.token);
}
class TokenAndOneGuidParameters {
  final String token;
  final Guid id;
  TokenAndOneGuidParameters(this.token,this.id);
}
class TokenAndDataParameters {
  final String token;
  final Map<String,dynamic> data;
  TokenAndDataParameters(this.token,this.data);
}