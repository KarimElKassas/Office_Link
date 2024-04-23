import 'package:dartz/dartz.dart';
import 'package:foe_archiving/data/models/additional_information_model.dart';
import 'package:foe_archiving/data/models/additional_information_type_model.dart';
import 'package:foe_archiving/data/models/department_model.dart';
import 'package:foe_archiving/data/models/direction_model.dart';
import 'package:foe_archiving/data/models/sector_model.dart';
import 'package:foe_archiving/data/models/tag_model.dart';
import 'package:foe_archiving/domain/usecase/common/get_department_by_id_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/get_departments_by_sector_use_case.dart';

import '../../core/error/failure.dart';
import '../../core/use_case/base_use_case.dart';

abstract class BaseCommonRepository {
  Future<Either<Failure, List<DirectionModel>>> getDirections(OnlyTokenParameters parameters);
  Future<Either<Failure, List<TagModel>>> getTags(OnlyTokenParameters parameters);
  Future<Either<Failure, List<DepartmentModel>>> getDepartmentsBySector(GetDepartmentsBySectorParameters parameters);
  Future<Either<Failure, List<SectorModel>>> getSectors(OnlyTokenParameters parameters);
  Future<Either<Failure, DepartmentModel>> getDepartmentById(GetDepartmentByIdParameters parameters);
  Future<Either<Failure, List<AdditionalInformationModel>>> getAllAdditionalInfoByLetter(TokenAndOneGuidParameters parameters);
  Future<Either<Failure, AdditionalInformationModel>> getAdditionalInfoById(TokenAndOneGuidParameters parameters);
  Future<Either<Failure, List<AdditionalInformationTypeModel>>> getAllAdditionalInfoTypes(OnlyTokenParameters parameters);
  Future<Either<Failure, AdditionalInformationTypeModel>> getAllAdditionalInfoTypeById(TokenAndOneGuidParameters parameters);
  Future<Either<Failure, AdditionalInformationModel>> createAdditionalInfo(TokenAndDataParameters parameters);
  Future<Either<Failure, DepartmentModel>> createDepartment(TokenAndDataParameters parameters);
  Future<Either<Failure, DirectionModel>> createDirection(TokenAndDataParameters parameters);
  Future<Either<Failure, TagModel>> createTag(TokenAndDataParameters parameters);
  Future<Either<Failure, DirectionModel>> getDirectionById(TokenAndOneGuidParameters parameters);

}