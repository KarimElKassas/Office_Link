import 'package:dartz/dartz.dart';
import 'package:foe_archiving/data/models/sector_model.dart';
import 'package:foe_archiving/data/models/tag_model.dart';
import 'package:foe_archiving/domain/repository/base_common_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../../../data/models/direction_model.dart';

class GetSectorsUseCase extends BaseUseCase<List<SectorModel>, OnlyTokenParameters> {
  BaseCommonRepository commonRepository;
  GetSectorsUseCase(this.commonRepository);

  @override
  Future<Either<Failure, List<SectorModel>>> call(OnlyTokenParameters parameters)async {
    return await commonRepository.getSectors(parameters);
  }
}