import 'package:dartz/dartz.dart';
import 'package:foe_archiving/domain/repository/base_contract_repository.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_case/base_use_case.dart';

class CreateContractUseCase extends BaseUseCase<String, TokenAndDataParameters> {
  BaseContractRepository contractRepository;
  CreateContractUseCase(this.contractRepository);

  @override
  Future<Either<Failure, String>> call(TokenAndDataParameters parameters)async {
    return await contractRepository.createContract(parameters);
  }
}
