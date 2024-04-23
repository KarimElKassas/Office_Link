import 'package:dartz/dartz.dart';
import 'package:foe_archiving/domain/repository/base_contract_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_case/base_use_case.dart';
import '../../../data/models/letter_model.dart';
import '../../repository/base_letter_repository.dart';

class GetContractByIdUseCase extends BaseUseCase<LetterModel, TokenAndOneGuidParameters> {
  BaseContractRepository contractRepository;
  GetContractByIdUseCase(this.contractRepository);

  @override
  Future<Either<Failure, LetterModel>> call(TokenAndOneGuidParameters parameters)async {
    return await contractRepository.getContractById(parameters);
  }
}