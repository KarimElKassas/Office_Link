import 'package:dartz/dartz.dart';
import 'package:foe_archiving/data/models/additional_information_model.dart';
import 'package:foe_archiving/domain/repository/base_letter_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_case/base_use_case.dart';

class GetAdditionalInfoByLetterIdUseCase extends BaseUseCase<List<AdditionalInformationModel>, TokenAndOneGuidParameters> {
  BaseLetterRepository letterRepository;
  GetAdditionalInfoByLetterIdUseCase(this.letterRepository);

  @override
  Future<Either<Failure, List<AdditionalInformationModel>>> call(TokenAndOneGuidParameters parameters)async {
    return await letterRepository.getAdditionalInfoByLetterId(parameters);
  }
}