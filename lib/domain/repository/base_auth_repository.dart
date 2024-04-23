import 'package:dartz/dartz.dart';

import '../../core/error/failure.dart';
import '../../core/use_case/base_use_case.dart';
import '../../data/models/user_model.dart';
import '../usecase/auth/get_user_use_case.dart';
import '../usecase/auth/login_user_use_case.dart';

abstract class BaseAuthRepository {
  Future<Either<Failure, String>> loginUser(LoginUserParameters parameters);
  Future<Either<Failure, UserModel>> getUser(OnlyTokenParameters parameters);
}