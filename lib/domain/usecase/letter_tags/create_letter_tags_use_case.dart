import 'package:dartz/dartz.dart';
import 'package:foe_archiving/domain/repository/base_letter_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_case/base_use_case.dart';

class CreateLetterTagUseCase extends BaseUseCase<String, TokenAndDataParameters> {
  BaseLetterRepository letterRepository;
  CreateLetterTagUseCase(this.letterRepository);

  @override
  Future<Either<Failure, String>> call(TokenAndDataParameters parameters)async {
    return await letterRepository.createLetterTag(parameters);
  }
}
