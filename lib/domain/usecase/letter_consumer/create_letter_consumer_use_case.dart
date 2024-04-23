import 'package:dartz/dartz.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:foe_archiving/domain/repository/base_letter_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_case/base_use_case.dart';

class CreateLetterConsumerUseCase extends BaseUseCase<String, CreateLetterConsumersParameters> {
  BaseLetterRepository letterRepository;
  CreateLetterConsumerUseCase(this.letterRepository);

  @override
  Future<Either<Failure, String>> call(CreateLetterConsumersParameters parameters)async {
    return await letterRepository.createLetterConsumer(parameters);
  }
}
class CreateLetterConsumersParameters{
  final String token;
  final Guid letterId;
  final List<Map<String,dynamic>> data;

  CreateLetterConsumersParameters(this.token,this.letterId, this.data);
}