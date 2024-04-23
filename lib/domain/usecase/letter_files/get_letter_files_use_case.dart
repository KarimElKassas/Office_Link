import 'package:dartz/dartz.dart';
import 'package:foe_archiving/data/models/letter_model.dart';
import 'package:foe_archiving/domain/repository/base_letter_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_case/base_use_case.dart';

class GetLetterFilesUseCase extends BaseUseCase<List<LetterFilesModel>, TokenAndOneGuidParameters> {
  BaseLetterRepository letterRepository;
  GetLetterFilesUseCase(this.letterRepository);

  @override
  Future<Either<Failure, List<LetterFilesModel>>> call(TokenAndOneGuidParameters parameters)async {
    return await letterRepository.getLetterFiles(parameters);
  }
}
