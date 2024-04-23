import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_case/base_use_case.dart';
import '../../../data/models/letter_model.dart';
import '../../repository/base_letter_repository.dart';

class GetArchivedLetterByIdUseCase extends BaseUseCase<LetterModel, TokenAndOneGuidParameters> {
  BaseLetterRepository letterRepository;
  GetArchivedLetterByIdUseCase(this.letterRepository);

  @override
  Future<Either<Failure, LetterModel>> call(TokenAndOneGuidParameters parameters)async {
    return await letterRepository.getArchivedLetterById(parameters);
  }
}