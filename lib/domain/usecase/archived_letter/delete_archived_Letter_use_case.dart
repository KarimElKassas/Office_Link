





import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_case/base_use_case.dart';
import '../../repository/base_letter_repository.dart';

class DeleteInternalArchivedLetterUseCase extends BaseUseCase<String, TokenAndOneGuidParameters> {
  BaseLetterRepository letterRepository;
  DeleteInternalArchivedLetterUseCase(this.letterRepository);

  @override
  Future<Either<Failure, String>> call(TokenAndOneGuidParameters parameters)async {
    return await letterRepository.deleteInternalArchivedLetter(parameters);
  }
}