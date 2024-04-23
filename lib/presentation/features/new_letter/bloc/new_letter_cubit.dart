import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:foe_archiving/core/use_case/base_use_case.dart';
import 'package:foe_archiving/core/utils/app_version.dart';
import 'package:foe_archiving/domain/usecase/additional_information/add_additional_info_use_case.dart';
import 'package:foe_archiving/domain/usecase/archived_letter/create_archived_letter_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter/create_external_letter_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter/create_internal_default_letter_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter_consumer/create_letter_consumer_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter_files/create_letter_files_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter_tags/create_letter_tags_use_case.dart';
import 'package:foe_archiving/presentation/features/new_letter/bloc/new_letter_states.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_cubit.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/utils/prefs_helper.dart';
import '../../../../data/models/user_model.dart';

class NewLetterCubit extends Cubit<NewLetterStates>{
  NewLetterCubit() : super(NewLetterInitial());

  static NewLetterCubit get(context) => BlocProvider.of(context);
  final myToken = Preference.prefs.getString('sessionToken')!;

  CommonDataCubit commonDataCubit = sl<CommonDataCubit>();

  CreateInternalDefaultLetterUseCase createInternalDefaultLetterUseCase = sl<CreateInternalDefaultLetterUseCase>();
  CreateExternalLetterUseCase createExternalLetterUseCase = sl<CreateExternalLetterUseCase>();
  CreateLetterTagUseCase createLetterTagUseCase = sl<CreateLetterTagUseCase>();
  CreateLetterFileUseCase createLetterFileUseCase = sl<CreateLetterFileUseCase>();
  CreateLetterConsumerUseCase createLetterConsumerUseCase = sl<CreateLetterConsumerUseCase>();
  AddAdditionalInfoUseCase addAdditionalInfoUseCase = sl<AddAdditionalInfoUseCase>();
  CreateArchivedLetterUseCase createArchivedLetterUseCase = sl<CreateArchivedLetterUseCase>();

  TextEditingController letterAboutController = TextEditingController();
  TextEditingController letterNumberController = TextEditingController();
  TextEditingController letterContentController = TextEditingController();
  ScrollController scrollController = ScrollController();
  int letterIncomingOutgoingType = 1; // incoming letter 2 -> outgoing
  int letterDirectionType = 1; // Internal letter 2 -> External
  DateTime letterDate = DateTime.now();
  List<Guid> uploadTagsList = [];

  Map<int,String>? selectedLetterType;

  List<Map<int,String>> typesList = [
    {1 : "خطاب جديد"},
    {2 : "ارشفة خطاب وارد"},
    {3 : "ارشفة خطاب صادر"},
  ];

  void initLetterType(){
    selectedLetterType = typesList[0];
    if(sl<CommonDataCubit>().isSecretary()){
      typesList.add({4 : "خطاب خارجى"});
    }
  }
  void changeIncomingOutgoingType(int newValue){
    if(letterIncomingOutgoingType != newValue){
      letterIncomingOutgoingType = newValue;
      emit(NewLetterChangeIncomingOutgoingType());
    }
  }

  void changeSelectedLetterType(Map<int,String> newType){
    if(selectedLetterType != newType){
      selectedLetterType = newType;
      print("SELECTED TYPE :$selectedLetterType");
      emit(NewLetterChangeLetterType());
    }
  }
  void changeLetterDirectionType(int newValue){
    letterDirectionType = newValue;
    emit(NewLetterChangeLetterDirectionType());
  }
  void changeCalendarDate(DateTime newDate){
    letterDate = newDate;
    emit(NewLetterChangeDate());
  }

  Future<void> createInternalDefaultLetter() async {
    emit(NewLetterLoading());
    Map<String, dynamic> dataMap = {
      'letterAbout' : letterAboutController.text.toString(),
      'letterContent': letterContentController.text.toString(),
      'letterNumber': letterNumberController.text.toString(),
      'letterStateId': Constants.acceptedLetterStateGuid.toString(),
      'letterDate': DateTime.now().toString(),
      'confidentialityId': sl<CommonDataCubit>().securityLevel.toString(),
    };

    final result = await createInternalDefaultLetterUseCase(TokenAndDataParameters(myToken, dataMap));
    result.fold(
            (l) => emit(NewLetterError(l.errMessage)),
            (r)async{
              if(sl<CommonDataCubit>().selectedTagsList.isNotEmpty){
                for(var tag in sl<CommonDataCubit>().selectedTagsList){
                  await uploadLetterTags(Guid(r['letterId'].toString()), tag.tagId, myToken);
                }
              }
              if(sl<CommonDataCubit>().pickedFiles.isNotEmpty){
                await uploadLetterFiles(Guid(r['letterId'].toString()), myToken);
              }
              if(sl<CommonDataCubit>().selectedActionDepartmentsList.isNotEmpty || sl<CommonDataCubit>().selectedKnowDepartmentsList.isNotEmpty){
                print("NOT EMPTY LIST");
                await uploadLetterConsumers(Guid(r['letterId'].toString()), myToken);
              }
              if(sl<CommonDataCubit>().textControllersList.isNotEmpty || sl<CommonDataCubit>().dateTimeList.isNotEmpty){
                await uploadLetterAdditionalTextInfo(Guid(r['letterId'].toString()), myToken);
                await uploadLetterAdditionalDateInfo(Guid(r['letterId'].toString()), myToken);
              }
              clearTools();
              emit(NewLetterSuccess());
            });
  }
  bool isLetterIncoming = false;
  void changeLetterIncoming(bool newValue){
    if(isLetterIncoming != newValue){
      isLetterIncoming = newValue;
      emit(NewLetterChangeLetterIncoming());
    }
  }
  Future<void> createExternalLetter() async {
    emit(NewLetterLoading());
    Map<String, dynamic> dataMap = {
      'letterAbout' : letterAboutController.text.toString(),
      'letterContent': letterContentController.text.toString(),
      'letterNumber': letterNumberController.text.toString(),
      'letterStateId': Constants.acceptedLetterStateGuid.toString(),
      'letterDate': DateTime.now().toString(),
      'confidentialityId': sl<CommonDataCubit>().securityLevel.toString(),
      'directionId' : sl<CommonDataCubit>().selectedDirection!.directionId.toString(),
      'isIncoming' : isLetterIncoming
    };

    final result = await createExternalLetterUseCase(TokenAndDataParameters(myToken, dataMap));
    result.fold(
            (l) => emit(NewLetterError(l.errMessage)),
            (r)async{
          if(sl<CommonDataCubit>().selectedTagsList.isNotEmpty){
            for(var tag in sl<CommonDataCubit>().selectedTagsList){
              await uploadLetterTags(Guid(r['letterId'].toString()), tag.tagId, myToken);
            }
          }
          if(sl<CommonDataCubit>().pickedFiles.isNotEmpty){
            await uploadLetterFiles(Guid(r['letterId'].toString()), myToken);
          }
          if(sl<CommonDataCubit>().textControllersList.isNotEmpty || sl<CommonDataCubit>().dateTimeList.isNotEmpty){
            await uploadLetterAdditionalTextInfo(Guid(r['letterId'].toString()), myToken);
            await uploadLetterAdditionalDateInfo(Guid(r['letterId'].toString()), myToken);
          }
          clearTools();
          emit(NewLetterSuccess());
        });
  }

  Future<void> createArchivedLetter() async {
    emit(NewLetterLoading());
    bool isIncoming = selectedLetterType?.keys.first == 2;
    UserModel model = UserModel.fromJson(jsonDecode(Preference.getString("User")!) as Map<String,dynamic>);
    var departmentId = '';
    if(isIncoming){
      departmentId = commonDataCubit.selectedDepartmentModel!.departmentId.toString();
    }else{
      if(commonDataCubit.selectedActionDepartmentsList.isNotEmpty){
        departmentId = commonDataCubit.selectedActionDepartmentsList[0].departmentId.toString();
      }else{
        departmentId = commonDataCubit.selectedKnowDepartmentsList[0].departmentId.toString();
      }
    }
    Map<String, dynamic> dataMap = {
      'letterAbout' : letterAboutController.text.toString(),
      'letterContent': letterContentController.text.toString(),
      'letterNumber': letterNumberController.text.toString(),
      'letterStateId': Constants.acceptedLetterStateGuid.toString(),
      'confidentialityId': commonDataCubit.securityLevel.toString(),
      'letterDate': letterDate.toString(),
      'isIncomming': isIncoming,
      'departmentId' : departmentId
    };


    final result = await createArchivedLetterUseCase(TokenAndDataParameters(myToken, dataMap));
    result.fold(
            (l) => emit(NewLetterError(l.errMessage)),
            (letterId)async{
              print("LETTER ID : $letterId");
              if(sl<CommonDataCubit>().selectedTagsList.isNotEmpty){
                print("TAGS : ${sl<CommonDataCubit>().selectedTagsList}");
                for(var tag in sl<CommonDataCubit>().selectedTagsList){
                  uploadLetterTags(Guid(letterId), tag.tagId, myToken);
                }
              }
              if(sl<CommonDataCubit>().pickedFiles.isNotEmpty){
                await uploadLetterFiles(Guid(letterId), myToken);
              }
              if(sl<CommonDataCubit>().selectedActionDepartmentsList.isNotEmpty || sl<CommonDataCubit>().selectedKnowDepartmentsList.isNotEmpty){
                print("NOT EMPTY LIST");
                await uploadLetterConsumers(Guid(letterId), myToken);
              }
              if(sl<CommonDataCubit>().textControllersList.isNotEmpty || sl<CommonDataCubit>().dateTimeList.isNotEmpty){
                await uploadLetterAdditionalTextInfo(Guid(letterId), myToken);
                await uploadLetterAdditionalDateInfo(Guid(letterId), myToken);
              }
              clearTools();
              emit(NewLetterSuccess());
            });
  }

  void clearTools(){
    letterAboutController.clear();
    letterContentController.clear();
    letterNumberController.clear();
    sl<CommonDataCubit>().clearTools();
  }


  Future<void> uploadLetterTags(Guid letterId, Guid tagId,String token)async {
    var map = {
      'tagId': tagId.toString(),
      'letterId':letterId.toString(),
    };
    final result = await createLetterTagUseCase(TokenAndDataParameters(token,map));
    result.fold(
            (l) => emit(NewLetterError(l.errMessage)),
            (r) {});
  }

  Future<void> uploadLetterFiles(Guid letterId, String token)async {
    await sl<CommonDataCubit>().preparedFiles();
    var map = {
      'letterId': letterId.toString(),
      'files':sl<CommonDataCubit>().multipartFiles,
    };
    final result = await createLetterFileUseCase(TokenAndDataParameters(token,map));
    result.fold(
            (l) => emit(NewLetterError(l.errMessage)),
            (r) {});
  }

  Future<void> uploadLetterConsumers(Guid letterId, String token)async {
    sl<CommonDataCubit>().departmentLetterList();
    print("UPLOAD LIST : ${sl<CommonDataCubit>().uploadDepartmentsList}");
    final result = await createLetterConsumerUseCase(CreateLetterConsumersParameters(token,letterId,sl<CommonDataCubit>().uploadDepartmentsList));
    result.fold(
            (l) => emit(NewLetterError(l.errMessage)),
            (r) {});
  }

  Future<void> uploadLetterAdditionalTextInfo(Guid letterId, String token)async {
    var textList = sl<CommonDataCubit>().textControllersList;
    if(textList.isNotEmpty){
      for(int i = 0; i < textList.length; i++){
        var map = {
          'letterId': letterId.toString(),
          'description':textList[i].values.first.text.toString(),
          'additionalInformationTypeId':textList[i].keys.first.toString(),
          'valueType' : 2
        };

        final result = await addAdditionalInfoUseCase(TokenAndDataParameters(token,map));
        result.fold(
                (l) => emit(NewLetterError(l.errMessage)),
                (r) {});
      }
    }
  }
  Future<void> uploadLetterAdditionalDateInfo(Guid letterId, String token)async {
    var dateList = sl<CommonDataCubit>().dateTimeList;
    if(dateList.isNotEmpty){
      for(int i = 0; i < dateList.length; i++){
        var map = {
          'letterId': letterId.toString(),
          'date':dateList[i].values.first.toString(),
          'additionalInformationTypeId':dateList[i].keys.first.toString(),
          'valueType' : 1
        };

        final result = await addAdditionalInfoUseCase(TokenAndDataParameters(token,map));
        result.fold(
                (l) => emit(NewLetterError(l.errMessage)),
                (r) {});
      }
    }
  }

}