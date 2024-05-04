import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:foe_archiving/core/error/failure.dart';
import 'package:foe_archiving/core/use_case/base_use_case.dart';
import 'package:foe_archiving/data/datasource/remote/letters_remote_data_source.dart';
import 'package:foe_archiving/data/models/additional_information_model.dart';
import 'package:foe_archiving/data/models/letter_consumer_model.dart';
import 'package:foe_archiving/data/models/letter_model.dart';
import 'package:foe_archiving/domain/repository/base_letter_repository.dart';

import '../../domain/usecase/letter_consumer/create_letter_consumer_use_case.dart';

class LetterRepository extends BaseLetterRepository{
  BaseLetterRemoteDataSource letterRemoteDataSource;

  LetterRepository(this.letterRemoteDataSource);

  @override
  Future<Either<Failure, String>> createArchivedLetter(TokenAndDataParameters parameters)async {
    try{
      final result = await letterRemoteDataSource.createInternalArchivedLetter(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }
  }

  @override
  Future<Either<Failure, Map<String,dynamic>>> createInternalDefaultLetter(TokenAndDataParameters parameters)async {
    final result = await letterRemoteDataSource.createInternalDefaultLetter(parameters);
    return Right(result);
    try{
      final result = await letterRemoteDataSource.createInternalDefaultLetter(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }
  }

  @override
  Future<Either<Failure, String>> createLetterTag(TokenAndDataParameters parameters)async {
    try{
      final result = await letterRemoteDataSource.createLetterTag(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }
  }

  @override
  Future<Either<Failure, String>> createLetterFiles(TokenAndDataParameters parameters)async {
    final result = await letterRemoteDataSource.createLetterFile(parameters);
    return Right(result);
    try{
      final result = await letterRemoteDataSource.createLetterFile(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, String>> createLetterConsumer(CreateLetterConsumersParameters parameters)async {

    try{
      final result = await letterRemoteDataSource.createLetterConsumer(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, String>> addAdditionalInfo(TokenAndDataParameters parameters)async {
    try{
      final result = await letterRemoteDataSource.addAdditionalInfo(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, List<LetterModel>>> getAllInternalDefaultLetters(TokenAndDataParameters parameters)async {
    final result = await letterRemoteDataSource.getAllInternalDefaultLetters(parameters);
    return Right(result);
    try{
      final result = await letterRemoteDataSource.getAllInternalDefaultLetters(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, List<LetterConsumerModel>>> getLetterConsumers(TokenAndOneGuidParameters parameters)async {
    try{
      final result = await letterRemoteDataSource.getLetterConsumers(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }
  }

  @override
  Future<Either<Failure, LetterModel>> getInternalDefaultLetterById(TokenAndOneGuidParameters parameters)async {
    try{
      final result = await letterRemoteDataSource.getInternalDefaultLetterById(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, List<AdditionalInformationModel>>> getAdditionalInfoByLetterId(TokenAndOneGuidParameters parameters)async {
    try{
      final result = await letterRemoteDataSource.getAdditionalInfoByLetterId(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, List<LetterFilesModel>>> getLetterFiles(TokenAndOneGuidParameters parameters)async {
    try{
      final result = await letterRemoteDataSource.getLetterFiles(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, String>> deleteInternalDefaultLetter(TokenAndOneGuidParameters parameters)async {
    try{
      final result = await letterRemoteDataSource.deleteInternalDefaultLetter(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, List<LetterModel>>> getArchivedLetters(TokenAndDataParameters parameters)async {
    final result = await letterRemoteDataSource.getArchivedLetters(parameters);
    return Right(result);
    try{
      final result = await letterRemoteDataSource.getArchivedLetters(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, LetterModel>> getArchivedLetterById(TokenAndOneGuidParameters parameters)async {
    try{
      final result = await letterRemoteDataSource.getArchivedLetterById(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, Map<String,dynamic>>> createExternalLetter(TokenAndDataParameters parameters)async {
    try{
      final result = await letterRemoteDataSource.createExternalLetter(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, List<LetterModel>>> getAllExternalLetters(TokenAndDataParameters parameters)async {
    try{
      final result = await letterRemoteDataSource.getAllExternalLetters(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, LetterModel>> getExternalLetterById(TokenAndOneGuidParameters parameters)async {
    final result = await letterRemoteDataSource.getExternalLetterById(parameters);
    return Right(result);
    try{
      final result = await letterRemoteDataSource.getExternalLetterById(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, List<LetterModel>>> getAllOutgoingDefaultLetters(TokenAndDataParameters parameters)async {
    final result = await letterRemoteDataSource.getAllOutgoingDefaultLetters(parameters);
    return Right(result);
    try{
      final result = await letterRemoteDataSource.getAllOutgoingDefaultLetters(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }
      return left(e as ServerFailure);
    }

  }

  @override
  Future<Either<Failure, List<LetterModel>>> getArchivedOutgoingLetters(TokenAndDataParameters parameters)async {
    final result = await letterRemoteDataSource.getArchivedOutgoingLetters(parameters);
    return Right(result);
  }

  @override
  Future<Either<Failure, String>> deleteInternalArchivedLetter(TokenAndOneGuidParameters parameters) async {
    try{
      final result = await letterRemoteDataSource.deleteInternalArchivedLetter(parameters);
      return Right(result);
    }catch (e){
      if (e is DioException){
        return left(ServerFailure.fromDioError(e));
      }

      return left(e as ServerFailure);
    }

  }

}