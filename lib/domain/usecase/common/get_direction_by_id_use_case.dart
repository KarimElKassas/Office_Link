import 'package:dartz/dartz.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:foe_archiving/data/models/department_model.dart';
import 'package:foe_archiving/data/models/tag_model.dart';
import 'package:foe_archiving/domain/repository/base_common_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../../../data/models/direction_model.dart';

class GetDirectionByIdUseCase extends BaseUseCase<DirectionModel, TokenAndOneGuidParameters> {
  BaseCommonRepository commonRepository;
  GetDirectionByIdUseCase(this.commonRepository);

  @override
  Future<Either<Failure, DirectionModel>> call(TokenAndOneGuidParameters parameters)async {
    return await commonRepository.getDirectionById(parameters);
  }
}