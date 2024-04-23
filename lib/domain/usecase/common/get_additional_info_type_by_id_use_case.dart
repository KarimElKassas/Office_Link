import 'package:dartz/dartz.dart';
import 'package:foe_archiving/data/models/additional_information_model.dart';
import 'package:foe_archiving/data/models/additional_information_type_model.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_case/base_use_case.dart';
import '../../repository/base_common_repository.dart';

class GetAdditionalInfoTypeByIdUseCase extends BaseUseCase<AdditionalInformationTypeModel, TokenAndOneGuidParameters> {
  BaseCommonRepository commonRepository;
  GetAdditionalInfoTypeByIdUseCase(this.commonRepository);

  @override
  Future<Either<Failure, AdditionalInformationTypeModel>> call(TokenAndOneGuidParameters parameters)async {
    return await commonRepository.getAllAdditionalInfoTypeById(parameters);
  }
}

