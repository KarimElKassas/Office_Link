import 'package:dartz/dartz.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:foe_archiving/data/models/department_model.dart';
import 'package:foe_archiving/data/models/tag_model.dart';
import 'package:foe_archiving/domain/repository/base_common_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../../../data/models/direction_model.dart';

class GetDepartmentsBySectorUseCase extends BaseUseCase<List<DepartmentModel>, GetDepartmentsBySectorParameters> {
  BaseCommonRepository commonRepository;
  GetDepartmentsBySectorUseCase(this.commonRepository);

  @override
  Future<Either<Failure, List<DepartmentModel>>> call(GetDepartmentsBySectorParameters parameters)async {
    return await commonRepository.getDepartmentsBySector(parameters);
  }
}

class GetDepartmentsBySectorParameters {
  final String token;
  final Guid sectorId;

  GetDepartmentsBySectorParameters(this.token, this.sectorId);
}