import 'package:dartz/dartz.dart';
import 'package:foe_archiving/data/models/additional_information_model.dart';
import 'package:foe_archiving/data/models/department_model.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_case/base_use_case.dart';
import '../../repository/base_common_repository.dart';

class AddDepartmentUseCase extends BaseUseCase<DepartmentModel, TokenAndDataParameters> {
  BaseCommonRepository commonRepository;
  AddDepartmentUseCase(this.commonRepository);

  @override
  Future<Either<Failure, DepartmentModel>> call(TokenAndDataParameters parameters)async {
    return await commonRepository.createDepartment(parameters);
  }
}

