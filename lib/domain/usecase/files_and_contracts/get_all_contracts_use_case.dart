import 'package:dartz/dartz.dart';
import 'package:foe_archiving/domain/repository/base_contract_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_case/base_use_case.dart';
import '../../../data/models/letter_model.dart';
import '../../repository/base_letter_repository.dart';

class GetAllContractsUseCase extends BaseUseCase<List<LetterModel>, TokenAndDataParameters> {
  BaseContractRepository contractRepository;
  GetAllContractsUseCase(this.contractRepository);

  @override
  Future<Either<Failure, List<LetterModel>>> call(TokenAndDataParameters parameters)async {
    return await contractRepository.getAllContracts(parameters);
  }
}