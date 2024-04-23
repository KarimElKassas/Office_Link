import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:foe_archiving/core/use_case/base_use_case.dart';
import 'package:foe_archiving/data/models/additional_information_model.dart';
import 'package:foe_archiving/data/models/letter_consumer_model.dart';
import 'package:foe_archiving/domain/usecase/common/get_all_additional_info_by_letter_use_case.dart';
import 'package:foe_archiving/domain/usecase/common/get_department_by_id_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter/delete_internal_default_letter_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter/get_internal_default_letter_by_id_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter_consumer/get_letter_consumers_use_case.dart';
import 'package:foe_archiving/domain/usecase/letter_files/get_letter_files_use_case.dart';
import 'package:foe_archiving/presentation/features/letter_details/bloc/letter_details_states.dart';
import 'package:foe_archiving/presentation/shared/bloc/common_data_cubit.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/localization/strings_manager.dart';
import '../../../../core/theming/color_manager.dart';
import '../../../../core/utils/prefs_helper.dart';
import '../../../../data/models/letter_model.dart';
import '../../../../data/models/selected_department_model.dart';
import '../../../../data/models/user_model.dart';

class LetterDetailsCubit extends Cubit<LetterDetailsStates>{
  LetterDetailsCubit() : super(LetterDetailsInitial());

  static LetterDetailsCubit get(context) => BlocProvider.of(context);
  final myToken = Preference.prefs.getString('sessionToken')!;
  
  GetLetterConsumersUseCase getLetterConsumersUseCase = sl<GetLetterConsumersUseCase>();
  GetInternalDefaultLetterByIdUseCase getInternalDefaultLetterByIdUseCase = sl<GetInternalDefaultLetterByIdUseCase>();
  GetAllAdditionalInfoByLetterUseCase getAllAdditionalInfoByLetterUseCase = sl<GetAllAdditionalInfoByLetterUseCase>();
  GetLetterFilesUseCase getLetterFilesUseCase = sl<GetLetterFilesUseCase>();
  GetDepartmentByIdUseCase getDepartmentByIdUseCase = sl<GetDepartmentByIdUseCase>();
  DeleteInternalDefaultLetterUseCase defaultLetterUseCase = sl<DeleteInternalDefaultLetterUseCase>();

  List<SelectedDepartmentModel?> selectedActionDepartmentsList = [];
  List<SelectedDepartmentModel?> selectedKnowDepartmentsList = [];

  List<AdditionalInformationModel?> additionalInfoList = [];
  List<LetterFilesModel> filesList = [];
  List<LetterConsumerModel> consumersList = [];
  List<LetterModel> repliesList = [];

  LetterModel? letterModel;
  Color letterNumberColor = ColorManager.goldColor;
  List<Map<String,dynamic>> seenDepartmentsList = [];
  List<String?> unSeenDepartmentsList = [];

  CommonDataCubit commonDataCubit = sl<CommonDataCubit>();

  String letterAttachmentsToString(LetterModel model){
    if(filesList.isEmpty){
      return AppStrings.notFound.tr();
    }else if(filesList.length == 1){
      return AppStrings.oneFile.tr();
    }else if(filesList.length == 2){
      return AppStrings.twoFiles.tr();
    }else{
      return "${filesList.length} ${AppStrings.files.tr()}";
    }
  }
  Future<void> getLetterReplies(Guid letterId) async {
    emit(LetterDetailsLoading());
    if(letterModel!.repliesLetterIds != null){
      if(letterModel!.repliesLetterIds!.isNotEmpty){
        for(int i = 0; i < letterModel!.repliesLetterIds!.length;i++){
          final result = await getInternalDefaultLetterByIdUseCase(TokenAndOneGuidParameters(myToken,letterId));
          result.fold(
                  (l) => emit(LetterDetailsError(l.errMessage)),
                  (r) {
                repliesList.add(r);
                getLetterConsumers(r.letterId);
                getAdditionalInfo(r.letterId);
                getLetterFiles(r.letterId);
              });
        }
        emit(LetterDetailsSuccess());
      }
    }

  }

  Future<String> receiverDepartmentName()async {
    if (consumersList.isEmpty) {
      return AppStrings.notFound.tr();
    } else {
      if (consumersList.length == 1) {
        return await getDepartmentName(consumersList[0].departmentId, true);
      } else {
        return AppStrings.manyDepartments.tr();
      }
    }
  }

  Future<void> getLetter(Guid letterId) async {
    emit(LetterDetailsLoading());
    print("LETTER ID :$letterId");
    final result = await getInternalDefaultLetterByIdUseCase(TokenAndOneGuidParameters(myToken,letterId));
    result.fold(
            (l) => emit(LetterDetailsError(l.errMessage)),
            (r) {
            letterModel = r;
          if(letterModel != null){
            getLetterConsumers(letterModel!.letterId);
            getAdditionalInfo(letterModel!.letterId);
            print("HERE ID :${letterModel!.letterId}");
            getLetterFiles(letterModel!.letterId);

          }
          emit(LetterDetailsSuccess());
        });
  }


  Future<void> getLetterConsumers(Guid letterId) async {
    emit(LetterDetailsLoading());

    final result = await getLetterConsumersUseCase(TokenAndOneGuidParameters(myToken,letterId));
    result.fold(
            (l) => emit(LetterDetailsError(l.errMessage)),
            (r) {
              consumersList = [];
              consumersList = r;
              if(isLetterMine(letterModel!)){
                getSeenDepartments();
                getUnSeenDepartments();
              }
              emit(LetterDetailsSuccess());
        });
  }
  Future<void> getAdditionalInfo(Guid letterId) async {
    emit(LetterDetailsLoading());

    final result = await getAllAdditionalInfoByLetterUseCase(TokenAndOneGuidParameters(myToken,letterId));
    result.fold(
            (l) => emit(LetterDetailsError(l.errMessage)),
            (r) {
              additionalInfoList = [];
              additionalInfoList = r;
              print("ADDITIONAL LIST :$additionalInfoList");
              emit(LetterDetailsSuccess());
        });
  }


  Future<void> getLetterFiles(Guid letterId) async {
    emit(LetterDetailsLoading());

    final result = await getLetterFilesUseCase(TokenAndOneGuidParameters(myToken,letterId));
    result.fold(
            (l) => emit(LetterDetailsError(l.errMessage)),
            (r) {
              filesList = [];
              filesList = r;
              emit(LetterDetailsSuccess());
        });
  }

  Future<void> deleteLetter() async {
    if(letterModel!.hasReply!){
      emit(LetterDetailsErrorDeleteLetter(AppStrings.cannotDeleteLetterHasReply.tr()));
      return;
    }
    emit(LetterDetailsLoading());
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await defaultLetterUseCase(TokenAndOneGuidParameters(myToken,letterModel!.letterId));
    result.fold(
            (l) => emit(LetterDetailsErrorDeleteLetter(l.errMessage)),
            (r) {
          //deleteLetterFromCache(letterModel.letterId, letterType);
          emit(LetterDetailsSuccessfulDeleteLetter());
        });
  }

  void changeLetterNumberColor(Color newColor){
    if(letterNumberColor != newColor){
      letterNumberColor = newColor;
      emit(LetterDetailsChangeColor());
    }
  }

  bool canReply(LetterModel model){
    var userMap = jsonDecode(Preference.getString("User").toString());
    UserModel myUserModel = UserModel.fromJson(userMap);
    if(consumersList.isNotEmpty){
      if(consumersList.where((element) => element.departmentId == myUserModel.departmentId).isNotEmpty){
        var departmentRole = consumersList.where((element) => element.departmentId == myUserModel.departmentId).first;
        return departmentRole.requiredAction;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }

  bool isLetterMine(LetterModel letterModel){
    var userMap = jsonDecode(Preference.getString("User").toString());
    if(userMap != null){
      UserModel myUserModel = UserModel.fromJson(userMap);
      return myUserModel.departmentId == letterModel.departmentId;
    }else{
      return false;
    }
  }

  List<PlatformFile> pickedFiles = [];
  void preparePickedFiles(){
    if(filesList.isNotEmpty){
      for (var element in filesList) {
        pickedFiles.add(PlatformFile(name: element.fileName, size: 0,path: element.filePath));
      }
    }
  }

  void getSeenDepartments()async{
    print("CONS : $consumersList");
    if(consumersList.isNotEmpty){

      List<LetterConsumerModel>? seenList = consumersList.where((element) => element.isSeen == true).toList();
      print("SEEN LIST : $seenList");
      if(seenList.isNotEmpty){
        for(int i = 0; i< seenList.length;i++){
          String name = await getDepartmentName(seenList[i].departmentId,false);
          if(name != "EMPTY"){
            Map<String,dynamic> data = {'departmentName': name, 'seenAt' : seenList[i].seenAt};
            seenDepartmentsList.add(data);
          }
        }
      }
    }
  }
  void getUnSeenDepartments()async{
    if(consumersList.isNotEmpty){
      List<LetterConsumerModel>? unSeenList = consumersList.where((element) => element.isSeen == false).toList();
      if(unSeenList.isNotEmpty){
        for(int i = 0; i< unSeenList.length;i++){
          String name = await getDepartmentName(unSeenList[i].departmentId,false);
          if(name != "EMPTY"){
            unSeenDepartmentsList.add(name);
          }
        }
      }
    }
  }
  Future<String> getDepartmentName(Guid departmentId, bool withoutEmit) async {
    final sessionToken = Preference.prefs.getString("sessionToken")!;
    final result = await getDepartmentByIdUseCase(GetDepartmentByIdParameters(myToken,departmentId));
    String name = '';
    result.fold(
            (l) {
          emit(LetterDetailsError(l.errMessage));
          name = 'EMPTY';
        },
            (r) {
          print("NAME HERE IS :$r");
          name = r.departmentName;
          if(!withoutEmit){
            emit(LetterDetailsSuccess());
          }
        });
    return name;
  }

/*
  void prepareDepartmentsList(LetterModel? model){
    if(model != null){
      for (var letterDepartment in model.departmentLetters) {
        var department = departmentsList.where((element) => element.departmentId == letterDepartment.departmentId).first;
        var sector = commonDataCubit.sectorsList.where((element) => element.sectorId == department.sectorId).first;
        if(letterDepartment.requiredAction){
          selectedActionDepartmentsList.add(SelectedDepartmentModel(letterDepartment.departmentId, department.departmentName, sector.sectorId, sector.sectorName, AppStrings.action.tr()));
        }else{
          print("HERE ITEM : ${letterDepartment.departmentId}");
          selectedKnowDepartmentsList.add(SelectedDepartmentModel(letterDepartment.departmentId, department.departmentName, sector.sectorId, sector.sectorName, AppStrings.know.tr()));
        }
      }
    }
  }
*/
}