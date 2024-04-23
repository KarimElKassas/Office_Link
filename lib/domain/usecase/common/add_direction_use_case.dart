import 'package:dartz/dartz.dart';
import 'package:foe_archiving/data/models/additional_information_model.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_case/base_use_case.dart';
import '../../../data/models/direction_model.dart';
import '../../repository/base_common_repository.dart';

class AddDirectionUseCase extends BaseUseCase<DirectionModel, TokenAndDataParameters> {
  BaseCommonRepository commonRepository;
  AddDirectionUseCase(this.commonRepository);

  @override
  Future<Either<Failure, DirectionModel>> call(TokenAndDataParameters parameters)async {
    return await commonRepository.createDirection(parameters);
  }
}

