import 'package:dartz/dartz.dart';
import 'package:foe_archiving/domain/repository/base_letter_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_case/base_use_case.dart';
import '../../../data/models/letter_model.dart';

class GetAllInternalDefaultLettersUseCase extends BaseUseCase<List<LetterModel>, TokenAndDataParameters> {
  BaseLetterRepository letterRepository;
  GetAllInternalDefaultLettersUseCase(this.letterRepository);

  @override
  Future<Either<Failure, List<LetterModel>>> call(TokenAndDataParameters parameters)async {
    return await letterRepository.getAllInternalDefaultLetters(parameters);
  }
}
