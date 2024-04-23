import 'package:dio/dio.dart';
import 'package:foe_archiving/core/error/failure.dart';
import 'package:foe_archiving/core/use_case/base_use_case.dart';
import 'package:foe_archiving/data/models/additional_information_model.dart';
import 'package:foe_archiving/data/models/additional_information_type_model.dart';
import 'package:foe_archiving/data/models/department_model.dart';
import 'package:foe_archiving/data/models/direction_model.dart';
import 'package:foe_archiving/data/models/sector_model.dart';
import 'package:foe_archiving/data/models/tag_model.dart';
import 'package:foe_archiving/domain/usecase/common/get_department_by_id_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/get_departments_by_sector_use_case.dart';

import '../../../core/network/endpoints.dart';
import '../../../core/utils/dio_helper.dart';

abstract class BaseCommonRemoteDataSource{
  Future<List<DirectionModel>> getDirections(OnlyTokenParameters token);
  Future<List<TagModel>> getTags(OnlyTokenParameters parameters);
  Future<List<SectorModel>> getSectors(OnlyTokenParameters parameters);
  Future<List<DepartmentModel>> getDepartmentsBySector(GetDepartmentsBySectorParameters parameters);
  Future<DepartmentModel> getDepartmentsById(GetDepartmentByIdParameters parameters);
  Future<AdditionalInformationModel> getAdditionalInfoById(TokenAndOneGuidParameters parameters);
  Future<AdditionalInformationTypeModel> getAdditionalInfoTypeById(TokenAndOneGuidParameters parameters);
  Future<List<AdditionalInformationTypeModel>> getAllAdditionalInfoTypes(OnlyTokenParameters parameters);
  Future<List<AdditionalInformationModel>> getAllAdditionalInfoByLetter(TokenAndOneGuidParameters parameters);
  Future<AdditionalInformationModel> createAdditionalInfo(TokenAndDataParameters parameters);
  Future<DepartmentModel> createDepartment(TokenAndDataParameters parameters);
  Future<DirectionModel> createDirection(TokenAndDataParameters parameters);
  Future<TagModel> createTag(TokenAndDataParameters parameters);
  Future<DirectionModel> getDirectionById(TokenAndOneGuidParameters parameters);
}

class CommonRemoteDataSource implements BaseCommonRemoteDataSource{
  @override
  Future<List<DirectionModel>> getDirections(OnlyTokenParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getDirections,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }));
    print("Get Directions => ${response.data}");
    return List<DirectionModel>.from((response.data as List).map((e) => DirectionModel.fromJson(e)));
  }

  @override
  Future<List<TagModel>> getTags(OnlyTokenParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getTags,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }));
    print("Get Tags => ${response.data}");
    return List<TagModel>.from((response.data as List).map((e) => TagModel.fromJson(e)));
  }

  @override
  Future<List<DepartmentModel>> getDepartmentsBySector(GetDepartmentsBySectorParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getDepartmentsBySector,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8',
        }),
      query: {'sectorId': parameters.sectorId.toString()}
    );

    print("Get Departments By Sector => ${response.data}");
    return List<DepartmentModel>.from((response.data as List).map((e) => DepartmentModel.fromJson(e)));
  }

  @override
  Future<List<SectorModel>> getSectors(OnlyTokenParameters parameters)async  {
    final response = await DioHelper.getData(
        url: EndPoints.getAllSectors,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }));
    print("Get Sectors Data => ${response.data}");
    return List<SectorModel>.from((response.data as List).map((e) => SectorModel.fromJson(e)));;
  }

  @override
  Future<DepartmentModel> getDepartmentsById(GetDepartmentByIdParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getDepartmentById,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8',
        }),
      query: {'departmentId': parameters.departmentId.toString()}
    );
    print("Get Department By Id Data =>${response.data}");
    return DepartmentModel.fromJson(response.data);
  }

  @override
  Future<AdditionalInformationModel> getAdditionalInfoById(TokenAndOneGuidParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getAdditionalInfoById,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8',
        }),
      query: {'additionalInformationId' : parameters.id.toString()}
    );
    print("Get Additional Info By Id Data =>${response.data}");
    return AdditionalInformationModel.fromJson(response.data);
  }

  @override
  Future<AdditionalInformationTypeModel> getAdditionalInfoTypeById(TokenAndOneGuidParameters parameters)async {
    final response = await DioHelper.getData(
      url: EndPoints.getAdditionalTypeById,
      options: Options(headers: {
        'Authorization': 'Bearer ${parameters.token}',
        'Content-Type': 'application/json; charset=utf-8',
      }),
      query: {'additionalInformationTypeId' : parameters.id.toString()}
    );
    print("Get Additional Info Type By Id Data =>${response.data}");
    return AdditionalInformationTypeModel.fromJson(response.data);
  }

  @override
  Future<List<AdditionalInformationModel>> getAllAdditionalInfoByLetter(TokenAndOneGuidParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getAllAdditionalInfoByLetterId,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8',
          'letterId' : parameters.id
        }));
    print("Get All Additional Info By Letter Data => ${response.data}");
    return List<AdditionalInformationModel>.from((response.data as List).map((e) => AdditionalInformationModel.fromJson(e)));;

  }

  @override
  Future<List<AdditionalInformationTypeModel>> getAllAdditionalInfoTypes(OnlyTokenParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getAllAdditionalTypes,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8',
        }));
    print("Get All Additional Info Types Data => ${response.data}");
    return List<AdditionalInformationTypeModel>.from((response.data as List).map((e) => AdditionalInformationTypeModel.fromJson(e)));;

  }

  @override
  Future<AdditionalInformationModel> createAdditionalInfo(TokenAndDataParameters parameters)async {
    final response = await DioHelper.postData(
      url: EndPoints.createAdditionalInfo,
      options: Options(headers: {
        'Authorization': 'Bearer ${parameters.token}',
        'Content-Type': 'application/json; charset=utf-8',
      }),
      data: parameters.data
    );
    print("Get Additional Info By Id Data =>${response.data}");
    return AdditionalInformationModel.fromJson(response.data);

  }

  @override
  Future<DepartmentModel> createDepartment(TokenAndDataParameters parameters)async {
    final response = await DioHelper.postData(
        url: EndPoints.createDepartment,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8',
        }),
        data: parameters.data
    );
    if(response.statusCode == 200){
      return DepartmentModel.fromJson(response.data);
    }else{
      throw ServerFailure.fromResponse(response.statusCode, response);
    }

  }

  @override
  Future<DirectionModel> createDirection(TokenAndDataParameters parameters)async {
    final response = await DioHelper.postData(
        url: EndPoints.createDirection,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8',
        }),
        data: parameters.data
    );
    if(response.statusCode == 200){
      return DirectionModel.fromJson(response.data);
    }else{
      throw ServerFailure.fromResponse(response.statusCode, response);
    }
  }

  @override
  Future<TagModel> createTag(TokenAndDataParameters parameters)async {
    final response = await DioHelper.postData(
        url: EndPoints.createTag,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8',
        }),
        data: parameters.data
    );
    if(response.statusCode == 200){
      return TagModel.fromJson(response.data);
    }else{
      throw ServerFailure.fromResponse(response.statusCode, response);
    }
  }
  @override
  Future<DirectionModel> getDirectionById(TokenAndOneGuidParameters parameters)async {
    final response = await DioHelper.getData(
        url: EndPoints.getDirectionById,
        options: Options(headers: {
          'Authorization': 'Bearer ${parameters.token}',
          'Content-Type': 'application/json; charset=utf-8'
        }),
        query: {'id' : parameters.id.toString()});
    print("RESPONSE : $response");
    return DirectionModel.fromJson(response.data);

  }

}