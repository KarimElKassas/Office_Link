import 'package:dartz/dartz.dart';
import 'package:foe_archiving/domain/repository/base_common_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../../../data/models/direction_model.dart';

class GetDirectionsUseCase extends BaseUseCase<List<DirectionModel>, OnlyTokenParameters> {
  BaseCommonRepository commonRepository;
  GetDirectionsUseCase(this.commonRepository);

  @override
  Future<Either<Failure, List<DirectionModel>>> call(OnlyTokenParameters parameters)async {
    return await commonRepository.getDirections(parameters);
  }
}