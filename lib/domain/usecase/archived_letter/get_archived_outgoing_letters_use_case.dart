import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_case/base_use_case.dart';
import '../../../data/models/letter_model.dart';
import '../../repository/base_letter_repository.dart';

class GetArchivedOutgoingLettersUseCase extends BaseUseCase<List<LetterModel>, TokenAndDataParameters> {
  BaseLetterRepository letterRepository;
  GetArchivedOutgoingLettersUseCase(this.letterRepository);

  @override
  Future<Either<Failure, List<LetterModel>>> call(TokenAndDataParameters parameters)async {
    return await letterRepository.getArchivedOutgoingLetters(parameters);
  }
}