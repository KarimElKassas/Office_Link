import 'package:dartz/dartz.dart';
import 'package:foe_archiving/domain/repository/base_auth_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/use_case/base_use_case.dart';

class LoginUserUseCase extends BaseUseCase<String, LoginUserParameters> {
  BaseAuthRepository authRepository;
  LoginUserUseCase(this.authRepository);

  @override
  Future<Either<Failure, String>> call(LoginUserParameters parameters)async {
    return await authRepository.loginUser(parameters);
  }
}

class LoginUserParameters {
  final Map<String,dynamic> data;

  LoginUserParameters(this.data);
}