import 'package:dartz/dartz.dart';
import 'package:foe_archiving/domain/repository/base_letter_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_case/base_use_case.dart';
import '../../../data/models/letter_model.dart';

class CreateInternalDefaultLetterUseCase extends BaseUseCase<Map<String,dynamic>, TokenAndDataParameters> {
  BaseLetterRepository letterRepository;
  CreateInternalDefaultLetterUseCase(this.letterRepository);

  @override
  Future<Either<Failure, Map<String,dynamic>>> call(TokenAndDataParameters parameters)async {
    return await letterRepository.createInternalDefaultLetter(parameters);
  }
}
