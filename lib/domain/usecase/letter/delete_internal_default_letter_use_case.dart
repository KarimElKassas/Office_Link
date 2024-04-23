import 'package:dartz/dartz.dart';
import 'package:foe_archiving/domain/repository/base_letter_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_case/base_use_case.dart';
import '../../../data/models/letter_model.dart';

class DeleteInternalDefaultLetterUseCase extends BaseUseCase<String, TokenAndOneGuidParameters> {
  BaseLetterRepository letterRepository;
  DeleteInternalDefaultLetterUseCase(this.letterRepository);

  @override
  Future<Either<Failure, String>> call(TokenAndOneGuidParameters parameters)async {
    return await letterRepository.deleteInternalDefaultLetter(parameters);
  }
}
