import 'package:dartz/dartz.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:foe_archiving/data/models/department_model.dart';
import 'package:foe_archiving/data/models/tag_model.dart';
import 'package:foe_archiving/domain/repository/base_common_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../../../data/models/direction_model.dart';

class GetDepartmentByIdUseCase extends BaseUseCase<DepartmentModel, GetDepartmentByIdParameters> {
  BaseCommonRepository commonRepository;
  GetDepartmentByIdUseCase(this.commonRepository);

  @override
  Future<Either<Failure, DepartmentModel>> call(GetDepartmentByIdParameters parameters)async {
    return await commonRepository.getDepartmentById(parameters);
  }
}

class GetDepartmentByIdParameters {
  final String token;
  final Guid departmentId;

  GetDepartmentByIdParameters(this.token, this.departmentId);
}