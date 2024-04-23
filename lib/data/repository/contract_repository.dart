import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:foe_archiving/core/error/failure.dart';
import 'package:foe_archiving/core/use_case/base_use_case.dart';
import 'package:foe_archiving/data/datasource/remote/contract_remote_data_source.dart';
import 'package:foe_archiving/data/models/letter_model.dart';
import 'package:foe_archiving/domain/repository/base_contract_repository.dart';

class ContractRepository extends BaseContractRepository{
  BaseContractRemoteDataSource contractRemoteDataSource;

  ContractRepository(this.contractRemoteDataSource);

  @override
  Future<Either<Failure, String>> createContract(TokenAndDataParameters parameters)async {
    try{
      final result = await contractRemoteDataSource.createContract(parameters);
      return Right(result);
    }catch (e){
      print("ERROR : $e");
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }
  }

  @override
  Future<Either<Failure, List<LetterModel>>> getAllContracts(TokenAndDataParameters parameters)async {
    try{
      final result = await contractRemoteDataSource.getAllContracts(parameters);
      return Right(result);
    }catch (e){
      print("ERROR : $e");
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }
  }

  @override
  Future<Either<Failure, LetterModel>> getContractById(TokenAndOneGuidParameters parameters)async {
    try{
      final result = await contractRemoteDataSource.getContractById(parameters);
      return Right(result);
    }catch (e){
      print("ERROR : $e");
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }

  }

}