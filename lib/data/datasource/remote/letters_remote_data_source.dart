import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:foe_archiving/core/use_case/base_use_case.dart';
import 'package:foe_archiving/data/models/additional_information_model.dart';
import 'package:foe_archiving/data/models/direction_model.dart';
import 'package:foe_archiving/data/models/letter_consumer_model.dart';
import 'package:foe_archiving/data/models/letter_model.dart';

import '../../../core/error/failure.dart';
import '../../../core/network/endpoints.dart';
import '../../../core/utils/dio_helper.dart';
import '../../../core/utils/prefs_helper.dart';
import '../../../domain/usecase/letter_consumer/create_letter_consumer_use_case.dart';
import '../../models/user_model.dart';

abstract class BaseLetterRemoteDataSource{
  Future<Map<String,dynamic>> createInternalDefaultLetter(TokenAndDataParameters parameters);
  Future<Map<String,dynamic>> createExternalLetter(TokenAndDataParameters parameters);
  Future<String> createInternalArchivedLetter(TokenAndDataParameters parameters);
  Future<String> createLetterTag(TokenAndDataParameters parameters);
  Future<String> createLetterFile(TokenAndDataParameters parameters);
  Future<List<LetterFilesModel>> getLetterFiles(TokenAndOneGuidParameters parameters);
  Future<String> createLetterConsumer(CreateLetterConsumersParameters parameters);
  Future<String> addAdditionalInfo(TokenAndDataParameters parameters);
  Future<List<AdditionalInformationModel>> getAdditionalInfoByLetterId(TokenAndOneGuidParameters parameters);
  Future<List<LetterModel>> getAllInternalDefaultLetters(TokenAndDataParameters parameters);
  Future<List<LetterModel>> getAllOutgoingDefaultLetters(TokenAndDataParameters parameters);
  Future<List<LetterModel>> getArchivedLetters(TokenAndDataParameters parameters);
  Future<List<LetterModel>> getArchivedOutgoingLetters(TokenAndDataParameters parameters);
  Future<List<LetterModel>> getAllExternalLetters(TokenAndDataParameters parameters);
  Future<LetterModel> getArchivedLetterById(TokenAndOneGuidParameters parameters);
  Future<LetterModel> getInternalDefaultLetterById(TokenAndOneGuidParameters parameters);
  Future<LetterModel> getExternalLetterById(TokenAndOneGuidParameters parameters);
  Future<List<LetterConsumerModel>> getLetterConsumers(TokenAndOneGuidParameters parameters);
  Future<String> deleteInternalDefaultLetter(TokenAndOneGuidParameters parameters);

}
class LetterRemoteDataSource implements BaseLetterRemoteDataSource{
  @override
  Future<String> createInternalArchivedLetter(TokenAndDataParameters parameters)async {
    final response = await DioHelper.postData(
      url: EndPoints.createInternalArchivedLetter,
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
  Future<Map<String,dynamic>> createInternalDefaultLetter(TokenAndDataParameters parameters)async {
    final response = await DioHelper.postData(
        url: EndPoints.createInternalDefaultLetter,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }),
        data: parameters.data,
    );
    print("Create Default Data => ${response.data}");
    if(response.statusCode == 200){
      Map<String, dynamic> data = response.data;
      return data;
    }else{
      throw ServerFailure(response.data['errors'][0].toString());
    }
  }

  @override
  Future<String> createLetterTag(TokenAndDataParameters parameters)async {
    final response = await DioHelper.postData(
        url: EndPoints.createLetterTag,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }),
        data: parameters.data);
    print("Create Letter Tag Data => ${response.data}");
    if(response.statusCode == 200){
      return "Success";
    }else{
      throw ServerFailure(response.data['errors'][0].toString());
    }
  }

  @override
  Future<String> createLetterFile(TokenAndDataParameters parameters)async {
    final response = await DioHelper.postData(
        url: EndPoints.createLetterFile,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }),
        query: {'letterId' : parameters.data['letterId'].toString()},
        data: FormData.fromMap(parameters.data));
    print("Create Letter File Data => ${response.data}");
    if(response.statusCode == 200){
      return "Success";
    }else{
      throw ServerFailure(response.data['errors'][0].toString());
    }

  }

  @override
  Future<String> createLetterConsumer(CreateLetterConsumersParameters parameters)async {
    final response = await DioHelper.postData(
        url: EndPoints.addLetterConsumers,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }),
        query: {'letterId' : parameters.letterId.toString()},
        data: parameters.data);
    print("Create Default Letter Consumer Data => ${response.data}");
    if(response.statusCode == 200){
      return "Success";
    }else{
      throw ServerFailure(response.data['errors'][0].toString());
    }

  }

  @override
  Future<String> addAdditionalInfo(TokenAndDataParameters parameters)async {
    final response = await DioHelper.postData(
        url: EndPoints.createAdditionalInfo,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }),
        data: parameters.data);
    print("Create Additional Info Data => ${response.data}");
    if(response.statusCode == 200){
      return "Success";
    }else{
      throw ServerFailure(response.data['errors'][0].toString());
    }
  }

  @override
  Future<List<LetterModel>> getAllInternalDefaultLetters(TokenAndDataParameters parameters)async {
    final response = await DioHelper.getData(
      url: EndPoints.getAllInternalDefaultLetters,
      options: Options(headers: {
        'Authorization': 'Bearer ${parameters.token}',
        'Content-Type': 'application/json; charset=utf-8'
      }),
      query: parameters.data

    );
    print("RESPONSE : $response");
    if(response.data != null){
      UserModel model = UserModel.fromJson(jsonDecode(Preference.getString("User")!) as Map<String,dynamic>);
      var totalPages = response.data['totalPages'];
      Preference.prefs.setInt("Department ${model.departmentId} Internal Default Total Pages", totalPages);
      return List<LetterModel>.from((response.data['data'] as List).map((e) => LetterModel.fromJson(e)));
    }else{
      return [];
    }
  }

  @override
  Future<List<LetterConsumerModel>> getLetterConsumers(TokenAndOneGuidParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getLetterConsumers,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }),
        query: {'letterId' : parameters.id.toString()});
    print("RESPONSE : $response");
    return List<LetterConsumerModel>.from((response.data as List).map((e) => LetterConsumerModel.fromJson(e)));
  }

  @override
  Future<LetterModel> getInternalDefaultLetterById(TokenAndOneGuidParameters parameters)async {
    print("PARAM : ${parameters.id.toString()}");
    final response = await DioHelper.getData(
        url: EndPoints.getInternalDefaultLetterById,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }),
        query: {'internalDefaultLetterId' : parameters.id.toString()});
    print("RESPONSE : $response");
    return LetterModel.fromJson(response.data);
  }

  @override
  Future<List<AdditionalInformationModel>> getAdditionalInfoByLetterId(TokenAndOneGuidParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getAllAdditionalInfoByLetterId,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }),
        query: {'letterId' : parameters.id.toString()});
    print("RESPONSE : $response");
    return List<AdditionalInformationModel>.from((response.data as List).map((e) => AdditionalInformationModel.fromJson(e)));

  }

  @override
  Future<List<LetterFilesModel>> getLetterFiles(TokenAndOneGuidParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getLetterFiles,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }),
        query: {'letterId' : parameters.id.toString()});
    print("RESPONSE : $response");
    return List<LetterFilesModel>.from((response.data as List).map((e) => LetterFilesModel.fromJson(e)));

  }

  @override
  Future<String> deleteInternalDefaultLetter(TokenAndOneGuidParameters parameters)async {
    final response = await DioHelper.postData(
        url: EndPoints.deleteInternalDefaultLetterById,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }),
        query: {'letterId' : parameters.id.toString()});
    if(response.statusCode == 200){
      return "Success";
    }else{
      throw ServerFailure(response.data['errors'][0].toString());
    }

  }

  @override
  Future<List<LetterModel>> getArchivedLetters(TokenAndDataParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getAllArchivedLetters,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }),
        query: parameters.data

    );
    print("RESPONSE : $response");
    if(response.data != null){
      UserModel model = UserModel.fromJson(jsonDecode(Preference.getString("User")!) as Map<String,dynamic>);
      var totalPages = response.data['totalPages'];
      Preference.prefs.setInt("Department ${model.departmentId} Archived Letter Total Pages", totalPages);
      return List<LetterModel>.from((response.data['data'] as List).map((e) => LetterModel.fromJson(e)));
    }else{
      return [];
    }
  }

  @override
  Future<LetterModel> getArchivedLetterById(TokenAndOneGuidParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getInternalArchivedLetterById,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }),
        query: {'archiveInternalLetterId' : parameters.id.toString()});
    print("RESPONSE : $response");
    return LetterModel.fromJson(response.data);
  }

  @override
  Future<Map<String,dynamic>> createExternalLetter(TokenAndDataParameters parameters)async {
    final response = await DioHelper.postData(
      url: EndPoints.createExternalLetter,
      options: Options(headers: {
        'Authorization': 'Bearer ${parameters.token}',
        'Content-Type': 'application/json; charset=utf-8'
      }),
      data: parameters.data,
    );
    if(response.statusCode == 200){
      return response.data;
    }else{
      throw ServerFailure(response.data['errors'][0].toString());
    }
  }

  @override
  Future<List<LetterModel>> getAllExternalLetters(TokenAndDataParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getAllExternalLetters,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }),
        query: parameters.data
    );
    print("RESPONSE : $response");
    if(response.data != null){
      UserModel model = UserModel.fromJson(jsonDecode(Preference.getString("User")!) as Map<String,dynamic>);
      var totalPages = response.data['totalPages'];
      Preference.prefs.setInt("Department ${model.departmentId} External Default Total Pages", totalPages);
      return List<LetterModel>.from((response.data['data'] as List).map((e) => LetterModel.fromJson(e)));
    }else{
      return [];
    }
  }

  @override
  Future<LetterModel> getExternalLetterById(TokenAndOneGuidParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getExternalLetterById,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }),
        query: {'archiveExternalLetterId' : parameters.id.toString()});
    print("RESPONSE : $response");
    return LetterModel.fromJson(response.data);
  }

  @override
  Future<List<LetterModel>> getAllOutgoingDefaultLetters(TokenAndDataParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getAllInternalDefaultLetters,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }),
        query: parameters.data

    );
    print("RESPONSE External : $response");
    if(response.data != null){
      UserModel model = UserModel.fromJson(jsonDecode(Preference.getString("User")!) as Map<String,dynamic>);
      var totalPages = response.data['totalPages'];
      Preference.prefs.setInt("Department ${model.departmentId} Outgoing Default Total Pages", totalPages);
      return List<LetterModel>.from((response.data['data'] as List).map((e) => LetterModel.fromJson(e)));
    }else{
      return [];
    }
  }

  @override
  Future<List<LetterModel>> getArchivedOutgoingLetters(TokenAndDataParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getAllArchivedLetters,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }),
        query: parameters.data

    );
    print("RESPONSE : $response");
    if(response.data != null){
      UserModel model = UserModel.fromJson(jsonDecode(Preference.getString("User")!) as Map<String,dynamic>);
      var totalPages = response.data['totalPages'];
      Preference.prefs.setInt("Department ${model.departmentId} Archived Outgoing Letter Total Pages", totalPages);
      return List<LetterModel>.from((response.data['data'] as List).map((e) => LetterModel.fromJson(e)));
    }else{
      return [];
    }
  }



}