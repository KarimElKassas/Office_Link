import 'package:dartz/dartz.dart';
import 'package:foe_archiving/domain/repository/base_letter_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_case/base_use_case.dart';
import '../../../data/models/letter_model.dart';

class GetInternalDefaultLetterByIdUseCase extends BaseUseCase<LetterModel, TokenAndOneGuidParameters> {
  BaseLetterRepository letterRepository;
  GetInternalDefaultLetterByIdUseCase(this.letterRepository);

  @override
  Future<Either<Failure, LetterModel>> call(TokenAndOneGuidParameters parameters)async {
    return await letterRepository.getInternalDefaultLetterById(parameters);
  }
}
