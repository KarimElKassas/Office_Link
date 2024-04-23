import 'package:dartz/dartz.dart';
import 'package:foe_archiving/data/models/additional_information_model.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_case/base_use_case.dart';
import '../../repository/base_common_repository.dart';

class CreateAdditionalInfoUseCase extends BaseUseCase<AdditionalInformationModel, TokenAndDataParameters> {
  BaseCommonRepository commonRepository;
  CreateAdditionalInfoUseCase(this.commonRepository);

  @override
  Future<Either<Failure, AdditionalInformationModel>> call(TokenAndDataParameters parameters)async {
    return await commonRepository.createAdditionalInfo(parameters);
  }
}

