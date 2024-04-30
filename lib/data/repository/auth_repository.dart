import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:foe_archiving/core/error/failure.dart';
import 'package:foe_archiving/core/use_case/base_use_case.dart';
import 'package:foe_archiving/data/datasource/remote/auth_remote_data_source.dart';
import 'package:foe_archiving/data/models/user_model.dart';
import 'package:foe_archiving/domain/repository/base_auth_repository.dart';
import 'package:foe_archiving/domain/usecase/auth/login_user_use_case.dart';

class AuthRepository extends BaseAuthRepository{
  BaseAuthRemoteDataSource authRemoteDataSource;

  AuthRepository(this.authRemoteDataSource);

  @override
  Future<Either<Failure, UserModel>> getUser(OnlyTokenParameters parameters)async {
    try{
      final result = await authRemoteDataSource.getUser(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }
  }

  @override
  Future<Either<Failure, String>> loginUser(parameters)async {
    try{
      final result = await authRemoteDataSource.loginUser(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, String>> changePassword(TokenAndDataParameters parameters)async {
    try{
      final result = await authRemoteDataSource.changePassword(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }

  }
}