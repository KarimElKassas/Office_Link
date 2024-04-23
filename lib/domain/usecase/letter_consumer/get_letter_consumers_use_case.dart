import 'package:dartz/dartz.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:foe_archiving/data/models/letter_consumer_model.dart';
import 'package:foe_archiving/domain/repository/base_letter_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_case/base_use_case.dart';

class GetLetterConsumersUseCase extends BaseUseCase<List<LetterConsumerModel>, TokenAndOneGuidParameters> {
  BaseLetterRepository letterRepository;
  GetLetterConsumersUseCase(this.letterRepository);

  @override
  Future<Either<Failure, List<LetterConsumerModel>>> call(TokenAndOneGuidParameters parameters)async {
    return await letterRepository.getLetterConsumers(parameters);
  }
}
