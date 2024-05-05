import 'package:dartz/dartz.dart';
import 'package:foe_archiving/data/models/letter_model.dart';

import '../../core/error/failure.dart';
import '../../core/use_case/base_use_case.dart';
import '../../data/models/user_model.dart';
import '../usecase/auth/get_user_use_case.dart';
import '../usecase/auth/login_user_use_case.dart';

abstract class BaseContractRepository {
  Future<Either<Failure, String>> createContract(TokenAndDataParameters parameters);
  Future<Either<Failure, List<LetterModel>>> getAllContracts(TokenAndDataParameters parameters);
  Future<Either<Failure, LetterModel>> getContractById(TokenAndOneGuidParameters parameters);
  Future<Either<Failure, String>> deleteContract(TokenAndOneGuidParameters parameters);

}