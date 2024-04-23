import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archiving/core/use_case/base_use_case.dart';
import 'package:hive/hive.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/utils/prefs_helper.dart';
import '../../../../domain/usecase/auth/get_user_use_case.dart';
import '../../../../domain/usecase/auth/login_user_use_case.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates>{
  LoginCubit() : super(LoginInitState());

  static LoginCubit get(context)=> BlocProvider.of(context);
  LoginUserUseCase loginUserUseCase = sl<LoginUserUseCase>();
  GetUserUseCase getUserUseCase = sl<GetUserUseCase>();

  bool isPassword = true;
  bool isSecretary = false;
  IconData suffix = Icons.visibility_rounded;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    emit(LoginLoadingState());

    Map<String, dynamic> dataMap = {
      'userHandle' : nameController.text.toString(),
      'password': passwordController.text.toString()
    };

    final result = await loginUserUseCase(LoginUserParameters(dataMap));
    result.fold(
            (l) => emit(LoginErrorState(l.errMessage)),
            (r)async {
              await getUserData(r);
            });
  }

  Future<void> getUserData(String sessionToken) async {
    emit(LoginLoadingState());
    final result = await getUserUseCase(OnlyTokenParameters(sessionToken));
    result.fold(
            (l) => emit(LoginErrorState(l.errMessage)),
            (r) {
              var data = jsonEncode(r.toJson());
              Preference.prefs.setString("sessionToken", sessionToken);
              Preference.prefs.setString("User", data);
              emit(LoginSuccessState());
            });
  }

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_rounded : Icons.visibility_off_rounded;

    emit(LoginChangePassVisibility());
  }
  Future<void> cacheUserData(Map<String, dynamic> userData) async {
    final userBox = Hive.box<Map<String, dynamic>>('Users');
    await userBox.put(userData['userId'], userData);
  }
}