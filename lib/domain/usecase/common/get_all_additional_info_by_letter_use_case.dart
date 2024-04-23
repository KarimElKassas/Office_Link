import 'package:dartz/dartz.dart';
import 'package:foe_archiving/data/models/additional_information_model.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_case/base_use_case.dart';
import '../../repository/base_common_repository.dart';

class GetAllAdditionalInfoByLetterUseCase extends BaseUseCase<List<AdditionalInformationModel>, TokenAndOneGuidParameters> {
  BaseCommonRepository commonRepository;
  GetAllAdditionalInfoByLetterUseCase(this.commonRepository);

  @override
  Future<Either<Failure, List<AdditionalInformationModel>>> call(TokenAndOneGuidParameters parameters)async {
    return await commonRepository.getAllAdditionalInfoByLetter(parameters);
  }
}

