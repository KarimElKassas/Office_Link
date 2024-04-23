import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:foe_archiving/core/error/failure.dart';
import 'package:foe_archiving/core/use_case/base_use_case.dart';
import 'package:foe_archiving/data/datasource/remote/auth_remote_data_source.dart';
import 'package:foe_archiving/data/datasource/remote/common_remote_data_source.dart';
import 'package:foe_archiving/data/models/additional_information_model.dart';
import 'package:foe_archiving/data/models/additional_information_type_model.dart';
import 'package:foe_archiving/data/models/department_model.dart';
import 'package:foe_archiving/data/models/direction_model.dart';
import 'package:foe_archiving/data/models/sector_model.dart';
import 'package:foe_archiving/data/models/tag_model.dart';
import 'package:foe_archiving/domain/repository/base_common_repository.dart';
import 'package:foe_archiving/domain/usecase/common/get_department_by_id_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/get_departments_by_sector_use_case.dart';

class CommonRepository extends BaseCommonRepository{
  BaseCommonRemoteDataSource commonRemoteDataSource;

  CommonRepository(this.commonRemoteDataSource);

  @override
  Future<Either<Failure, List<DirectionModel>>> getDirections(OnlyTokenParameters parameters)async {
    try{
      final result = await commonRemoteDataSource.getDirections(parameters);
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
  Future<Either<Failure, List<TagModel>>> getTags(OnlyTokenParameters parameters)async {
    try{
      final result = await commonRemoteDataSource.getTags(parameters);
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
  Future<Either<Failure, List<DepartmentModel>>> getDepartmentsBySector(GetDepartmentsBySectorParameters parameters)async {
    try{
      final result = await commonRemoteDataSource.getDepartmentsBySector(parameters);
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
  Future<Either<Failure, List<SectorModel>>> getSectors(OnlyTokenParameters parameters)async {
    try{
      final result = await commonRemoteDataSource.getSectors(parameters);
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
  Future<Either<Failure, DepartmentModel>> getDepartmentById(GetDepartmentByIdParameters parameters)async {
    try{
      final result = await commonRemoteDataSource.getDepartmentsById(parameters);
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
  Future<Either<Failure, AdditionalInformationModel>> getAdditionalInfoById(TokenAndOneGuidParameters parameters)async {
    try{
      final result = await commonRemoteDataSource.getAdditionalInfoById(parameters);
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
  Future<Either<Failure, List<AdditionalInformationModel>>> getAllAdditionalInfoByLetter(TokenAndOneGuidParameters parameters)async {
    try{
      final result = await commonRemoteDataSource.getAllAdditionalInfoByLetter(parameters);
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
  Future<Either<Failure, AdditionalInformationTypeModel>> getAllAdditionalInfoTypeById(TokenAndOneGuidParameters parameters)async {
    try{
      final result = await commonRemoteDataSource.getAdditionalInfoTypeById(parameters);
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
  Future<Either<Failure, List<AdditionalInformationTypeModel>>> getAllAdditionalInfoTypes(OnlyTokenParameters parameters)async {
    final result = await commonRemoteDataSource.getAllAdditionalInfoTypes(parameters);
    return Right(result);
    try{
      final result = await commonRemoteDataSource.getAllAdditionalInfoTypes(parameters);
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
  Future<Either<Failure, AdditionalInformationModel>> createAdditionalInfo(TokenAndDataParameters parameters)async {
    try{
      final result = await commonRemoteDataSource.createAdditionalInfo(parameters);
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
  Future<Either<Failure, DepartmentModel>> createDepartment(TokenAndDataParameters parameters)async {
    try{
      final result = await commonRemoteDataSource.createDepartment(parameters);
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
  Future<Either<Failure, DirectionModel>> createDirection(TokenAndDataParameters parameters)async {
    try{
      final result = await commonRemoteDataSource.createDirection(parameters);
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
  Future<Either<Failure, TagModel>> createTag(TokenAndDataParameters parameters)async {
    try{
      final result = await commonRemoteDataSource.createTag(parameters);
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
  Future<Either<Failure, DirectionModel>> getDirectionById(TokenAndOneGuidParameters parameters)async {
    try{
      final result = await commonRemoteDataSource.getDirectionById(parameters);
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