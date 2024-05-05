


import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/use_case/base_use_case.dart';
import '../../repository/base_contract_repository.dart';

class DeleteContractUseCase extends BaseUseCase<String, TokenAndOneGuidParameters> {
  BaseContractRepository contractRepository;
  DeleteContractUseCase(this.contractRepository);

  @override
  Future<Either<Failure, String>> call(TokenAndOneGuidParameters parameters)async {
    return await contractRepository.deleteContract(parameters);
  }
}