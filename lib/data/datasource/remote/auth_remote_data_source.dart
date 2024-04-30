import 'package:dio/dio.dart';

import '../../../core/error/failure.dart';
import '../../../core/network/endpoints.dart';
import '../../../core/use_case/base_use_case.dart';
import '../../../core/utils/dio_helper.dart';
import '../../../domain/usecase/auth/login_user_use_case.dart';
import '../../models/user_model.dart';

abstract class BaseAuthRemoteDataSource{
  Future<String> loginUser(LoginUserParameters parameters);
  Future<String> changePassword(TokenAndDataParameters parameters);
  Future<UserModel> getUser(OnlyTokenParameters parameters);
}

class AuthRemoteDataSource implements BaseAuthRemoteDataSource{
  @override
  Future<UserModel> getUser(OnlyTokenParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getUser,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
    }));
    Map<String, dynamic> data = response.data;
    print("Get User Data => $data");
    return UserModel.fromJson(data);
  }

  @override
  Future<String> loginUser(LoginUserParameters parameters)async {
    final response = await DioHelper.postData(url: EndPoints.login, data: parameters.data);
    print("Login User Data => ${response.data}");
    if(response.statusCode == 200){
      return response.data["jwtToken"];
    }else{
      throw ServerFailure(response.data['errors'][0].toString());

    }
  }

  @override
  Future<String> changePassword(TokenAndDataParameters parameters)async {
    final response = await DioHelper.postData(
        url: EndPoints.changePassword,
        query: parameters.data,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }));
    print("Change Password Data => ${response.data}");
    if(response.statusCode == 200){
      return response.statusMessage??"OKAY";
    }else{
      throw ServerFailure(response.data['errors'][0].toString());

    }
  }
}