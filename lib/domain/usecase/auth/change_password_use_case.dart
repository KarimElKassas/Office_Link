import 'package:dartz/dartz.dart';
import 'package:foe_archiving/domain/repository/base_auth_repository.dart';
import 'package:foe_archiving/domain/usecase/auth/login_user_use_case.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/use_case/base_use_case.dart';

class ChangePasswordUseCase extends BaseUseCase<String, TokenAndDataParameters> {
  BaseAuthRepository authRepository;
  ChangePasswordUseCase(this.authRepository);

  @override
  Future<Either<Failure, String>> call(TokenAndDataParameters parameters)async {
    return await authRepository.changePassword(parameters);
  }
}
