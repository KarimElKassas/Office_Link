import 'package:dartz/dartz.dart';
import 'package:foe_archiving/domain/repository/base_letter_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_case/base_use_case.dart';

class CreateExternalLetterUseCase extends BaseUseCase<Map<String,dynamic>, TokenAndDataParameters> {
  BaseLetterRepository letterRepository;
  CreateExternalLetterUseCase(this.letterRepository);

  @override
  Future<Either<Failure, Map<String,dynamic>>> call(TokenAndDataParameters parameters)async {
    return await letterRepository.createExternalLetter(parameters);
  }
}
