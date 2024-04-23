import 'package:dartz/dartz.dart';
import 'package:foe_archiving/domain/repository/base_auth_repository.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/use_case/base_use_case.dart';
import '../../../data/models/user_model.dart';

class GetUserUseCase extends BaseUseCase<UserModel, OnlyTokenParameters> {
  BaseAuthRepository authRepository;
  GetUserUseCase(this.authRepository);

  @override
  Future<Either<Failure, UserModel>> call(OnlyTokenParameters parameters)async {
    return await authRepository.getUser(parameters);
  }
}
