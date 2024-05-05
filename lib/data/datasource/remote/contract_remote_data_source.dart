import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:foe_archiving/core/use_case/base_use_case.dart';
import 'package:foe_archiving/data/models/letter_model.dart';

import '../../../core/error/failure.dart';
import '../../../core/network/endpoints.dart';
import '../../../core/utils/dio_helper.dart';
import '../../../core/utils/prefs_helper.dart';
import '../../models/user_model.dart';

abstract class BaseContractRemoteDataSource{
  Future<String> createContract(TokenAndDataParameters parameters);
  Future<List<LetterModel>> getAllContracts(TokenAndDataParameters parameters);
  Future<LetterModel> getContractById(TokenAndOneGuidParameters parameters);
  Future<String> deleteContract(TokenAndOneGuidParameters parameters);
}

class ContractRemoteDataSource implements BaseContractRemoteDataSource{
  @override
  Future<String> createContract(TokenAndDataParameters parameters)async {
    final response = await DioHelper.postData(
      url: EndPoints.createContract,
      options: Options(headers: {
        'Authorization': 'Bearer ${parameters.token}',
        'Content-Type': 'application/json; charset=utf-8'
      }),
      data: parameters.data,
    );
    if(response.statusCode == 200){
      return response.data['letterId'].toString();
    }else{
      throw ServerFailure(response.data['errors'][0].toString());
    }
  }

  @override
  Future<List<LetterModel>> getAllContracts(TokenAndDataParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getAllContracts,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }),
        query: parameters.data

    );
    print("RESPONSE Contracts : $response");
    if(response.data != null){
      UserModel model = UserModel.fromJson(jsonDecode(Preference.getString("User")!) as Map<String,dynamic>);
      var totalPages = response.data['totalPages'];
      Preference.prefs.setInt("Department ${model.departmentId} Contracts Total Pages", totalPages);
      return List<LetterModel>.from((response.data['data'] as List).map((e) => LetterModel.fromJson(e)));
    }else{
      return [];
    }
  }

  @override
  Future<LetterModel> getContractById(TokenAndOneGuidParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getContractById,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }),
        query: {'id' : parameters.id.toString()});
    print("RESPONSE : $response");
    return LetterModel.fromJson(response.data);
  }

  @override
  Future<String> deleteContract(TokenAndOneGuidParameters parameters) async{
    final response = await DioHelper.postData(
        url: EndPoints.deleteContract,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }),
        query: {'id': parameters.id.toString()});
    if(response.statusCode == 200){
      return "Success";
    }else{
      throw ServerFailure(response.data['errors'][0].toString());
    }
  }

}